extends Node
class_name SFXPlayer

@export var bus_name: String = "SFX"
@export var initial_player_count: int = 3

# Pool of audio players
var _players: Array[AudioStreamPlayer] = []

# Active sounds by resource path
var _active := {}  # Dictionary mapping resource path to AudioStreamPlayer

# Expiration timers: { path: { player: AudioStreamPlayer, timer: float } }
var _timers := {}  # Dictionary mapping resource path to info dict

func _ready() -> void:
	# Pre-fill the pool
	for i in range(initial_player_count):
		_add_player()

func _process(delta: float) -> void:
	# Tick down expiration timers
	for path in _timers.keys().duplicate():
		_timers[path].timer -= delta
		if _timers[path].timer <= 0:
			_stop_by_path(path)

# Play by filename lookup
func play_from_id(filename: String, volume := 1.0) -> void:
	var sfx: SoundEffect = SFXScanner.get_effect_by_filename(filename)
	if sfx:
		play(sfx, volume)

# Stop by filename lookup
func stop_by_id(filename: String) -> void:
	var sfx: SoundEffect = SFXScanner.get_effect_by_filename(filename)
	if sfx and sfx.sound_file:
		_stop_by_path(sfx.sound_file.resource_path)

# Main play method
func play(sfx: SoundEffect, volume := 1.0) -> void:
	if not sfx or not sfx.sound_file:
		push_error("Invalid sound effect or missing file")
		return

	var path := sfx.sound_file.resource_path

	# If already playing and not interruptible, just refresh timer
	if _active.has(path):
		var existing = _active[path]
		if not sfx.interrupt:
			if sfx.expiration_time > 0 and _timers.has(path):
				_timers[path].timer = sfx.expiration_time
			return
		# Interrupt: stop and clean up
		_stop_player(existing, path)

	# Acquire a free player
	var player = _get_player()

	# Assign the imported stream directly
	player.stream = sfx.sound_file
	player.volume_db = linear_to_db(volume)

	# Reconnect finished signal only if non-looping
	_disconnect_finished(player)
	if not sfx.looping:
		player.finished.connect(self._on_finished.bind(player, path))

	player.play()

	# Track active and timers
	_active[path] = player
	if sfx.expiration_time > 0:
		_timers[path] = {"player": player, "timer": sfx.expiration_time}

# Stop a specific sound
func stop(sfx: SoundEffect) -> void:
	if not sfx or not sfx.sound_file:
		return
	_stop_by_path(sfx.sound_file.resource_path)

# Stop all sounds
func stop_all() -> void:
	for p in _players:
		p.stop()
	_active.clear()
	_timers.clear()

# Called when a non-looping player finishes
func _on_finished(player: AudioStreamPlayer, path: String) -> void:
	if _active.has(path):
		_active.erase(path)
	if _timers.has(path):
		_timers.erase(path)

# Internal helpers
func _stop_by_path(path: String) -> void:
	if _active.has(path):
		_stop_player(_active[path], path)

func _stop_player(player: AudioStreamPlayer, path: String) -> void:
	player.stop()
	_active.erase(path)
	_timers.erase(path)
	_disconnect_finished(player)

func _get_player() -> AudioStreamPlayer:
	for p in _players:
		if not p.playing:
			return p
	return _add_player()

func _add_player() -> AudioStreamPlayer:
	var p = AudioStreamPlayer.new()
	p.bus = bus_name
	add_child(p)
	_players.append(p)
	return p

func _disconnect_finished(player: AudioStreamPlayer) -> void:
	for conn in player.finished.get_connections():
		var cb = conn.callable
		if cb.get_object() == self and cb.get_method() == "_on_finished":
			player.finished.disconnect(cb)
