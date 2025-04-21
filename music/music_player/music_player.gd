extends Node
class_name MusicPlayer

@export var current_song: Song
@export var bus_name: String = "Music"
@export var song_transition_curve: Curve

const FULL_DB: float = 0.0
const MUTE_DB: float = -64.0
const TRANSITION_TIME: float = 2.0
const VOLUME_TRANSITION_TIME: float = 0.5

@onready var players: Array[AudioStreamPlayer] = [$AudioStreamPlayerA, $AudioStreamPlayerB]
var active_idx: int = 0

var in_loop_crossfade: bool = false
var is_song_transition: bool = false
var transition_time_elapsed: float = 0.0
var next_song: Song

var volume_tween: Tween

func _ready() -> void:
	for player in players:
		player.bus = bus_name
		player.volume_db = MUTE_DB

func _process(delta: float) -> void:
	if not _any_playing():
		return
	if not is_song_transition:
		_handle_loop_crossfade()
	_handle_song_transition(delta)

# Public API
func play(from_sec: float = 0.0) -> void:
	_reset_players()
	active_idx = 0
	var active = _active()
	active.stream = current_song.song_file
	active.volume_db = FULL_DB
	active.play(from_sec)

func stop() -> void:
	_reset_players()

func is_playing() -> bool:
	return _active().playing

func get_position() -> float:
	return _active().get_playback_position()

func get_length() -> float:
	var s = _active().stream
	if s != null and s.has_method("get_length"):
		return s.get_length()
	return 0.0

func transition_to_song(song: Song, at_point: float = 0.0) -> void:
	if not _any_playing():
		current_song = song
		play(at_point)
		return
	next_song = song
	is_song_transition = true
	transition_time_elapsed = 0.0
	var inactive = _inactive()
	inactive.stream = song.song_file
	inactive.volume_db = MUTE_DB
	inactive.play(at_point)

func set_volume(level: float) -> void:
	level = max(level, 0.0)

	var target_db: float
	if level == 0.0:
		target_db = MUTE_DB
	else:
		target_db = linear_to_db(level)

	if volume_tween and volume_tween.is_valid():
		volume_tween.kill()

	volume_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	for player in players:
		volume_tween.tween_property(
			player, "volume_db",
			target_db,
			VOLUME_TRANSITION_TIME
		)

# Internal handlers
func _handle_song_transition(delta: float) -> void:
	if not is_song_transition:
		return
	transition_time_elapsed += delta
	var t = min(transition_time_elapsed / TRANSITION_TIME, 1.0)
	var fade_in = song_transition_curve.sample(t)
	var fade_out = song_transition_curve.sample(1.0 - t)
	var inactive = _inactive()
	var active = _active()
	inactive.volume_db = MUTE_DB + (-MUTE_DB) * fade_in
	active.volume_db   = MUTE_DB + (-MUTE_DB) * fade_out
	if transition_time_elapsed >= TRANSITION_TIME:
		active.stop()
		active.stream = null
		active_idx = 1 - active_idx
		is_song_transition = false
		active = _active()
		active.volume_db = FULL_DB

func _handle_loop_crossfade() -> void:
	var active = _active()
	var inactive = _inactive()
	var pos = active.get_playback_position()
	var fade_period = current_song.fade_period
	var fade_start = current_song.loop_end - fade_period

	if pos >= fade_start and not in_loop_crossfade:
		in_loop_crossfade = true
		inactive.stream = current_song.song_file
		inactive.volume_db = MUTE_DB
		inactive.play(current_song.loop_start)

	if in_loop_crossfade:
		var t = clamp((pos - fade_start) / fade_period, 0.0, 1.0)
		active.volume_db   = MUTE_DB + (-MUTE_DB) * current_song.fade_out_curve.sample(1.0 - t)
		inactive.volume_db = MUTE_DB + (-MUTE_DB) * current_song.fade_in_curve .sample(t)

	if pos >= current_song.loop_end:
		active.stop()
		active.stream = null
		active_idx = 1 - active_idx
		in_loop_crossfade = false
		_active().volume_db   = FULL_DB
		_inactive().volume_db = MUTE_DB

# Utility methods
func _reset_players() -> void:
	for player in players:
		player.stop()
		player.stream = null
		player.volume_db = MUTE_DB
	in_loop_crossfade = false
	is_song_transition = false

func _active() -> AudioStreamPlayer:
	return players[active_idx]

func _inactive() -> AudioStreamPlayer:
	return players[1 - active_idx]

func _any_playing() -> bool:
	for player in players:
		if player.playing:
			return true
	return false
