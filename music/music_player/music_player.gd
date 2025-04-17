extends Node
class_name MusicPlayer

@export var current_song: Song
@export var bus_name: String = "Music"

# Decibels: 0 dB = full, –24 dB = silent
const FULL_DB: float = 0.0
const MUTE_DB: float = -24.0

@onready var audio_a: AudioStreamPlayer = $AudioStreamPlayerA
@onready var audio_b: AudioStreamPlayer = $AudioStreamPlayerB

var is_a_playing: bool = true     # true = audio_a is the "active" stream
var in_crossfade: bool = false

func _ready() -> void:
	# Both players go to the same bus
	audio_a.bus = bus_name
	audio_b.bus = bus_name
	_mute_both()

func _process(delta: float) -> void:
	if not _is_any_playing():
		return
	_update_crossfade()

func play() -> void:
	_start_from(0.0)
	
func test_loop() -> void:                  
	_start_from(max(current_song.loop_end - 5.0, 0.0))
	
func stop() -> void:                       
	_reset_all()
	
func seek(pos_sec: float) -> void:         
	_start_from(pos_sec)

func is_playing()  -> bool:                
	return _active().playing
	
func get_position() -> float:              
	return _active().get_playback_position()
	
func get_length() -> float:
	var s = _active().stream
	return s.get_length() if s and s.has_method("get_length") else 0.0

func _start_from(offset_sec: float) -> void:
	_reset_all()                           # hard stop + clear state
	is_a_playing = true                    # always relaunch on "A"
	_active().stream = current_song.song_file
	_active().volume_db = FULL_DB
	_active().play(offset_sec)

func _reset_all() -> void:
	_stop_all()            # silent and clear
	in_crossfade = false
	is_a_playing = true
	_mute_both()

func _stop_all() -> void:
	for p in [audio_a, audio_b]:
		p.stop()
		p.stream = null
		p.volume_db = MUTE_DB

func _mute_both() -> void:
	audio_a.volume_db = MUTE_DB
	audio_b.volume_db = MUTE_DB

func _update_crossfade() -> void:
	var active = _active()
	var inactive = _inactive()
	var pos = active.get_playback_position()
	var fade_len = current_song.fade_period
	var start_fade = current_song.loop_end - fade_len

	# launch the other player when we hit the fade window
	if pos >= start_fade and not in_crossfade:
		in_crossfade = true
		inactive.stream = current_song.song_file
		inactive.volume_db = MUTE_DB
		inactive.play(current_song.loop_start)

	# drive the volumes inside the window
	if in_crossfade:
		var t = clamp((pos - start_fade) / fade_len, 0.0, 1.0)
		active.volume_db = MUTE_DB + current_song.fade_out_curve.sample(1.0 - t) * -MUTE_DB
		inactive.volume_db = MUTE_DB + current_song.fade_in_curve .sample(t) * -MUTE_DB

	# once we cross loop_end: stop old, flip flags, prep next round
	if pos >= current_song.loop_end:
		active.stop()
		active.stream = null
		is_a_playing = not is_a_playing
		in_crossfade = false
		_active().volume_db = FULL_DB   # new active up
		_inactive().volume_db = MUTE_DB   # new inactive silent

func _active()   -> AudioStreamPlayer: 
	return audio_a if is_a_playing else audio_b
	
func _inactive() -> AudioStreamPlayer: 
	return audio_b if is_a_playing else audio_a
	
func _is_any_playing() -> bool:        
	return audio_a.playing or audio_b.playing
