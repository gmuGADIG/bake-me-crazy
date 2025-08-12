extends Node
class_name SFXPlayer

@export var bus_name: String = "SFX"
@export var initial_player_count: int = 3

# Pool of audio players
var _players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	# Pre-fill the pool
	for i in range(initial_player_count):
		_add_player()

# Play by filename lookup
func play_from_id(filename: String, volume := 1.0) -> void:
	var sfx: SoundEffect = SFXScanner.get_effect_by_filename(filename)
	if sfx:
		play(sfx, volume)

# Main play method
func play(sfx: SoundEffect, volume := 1.0) -> void:
	if not sfx or not sfx.sound_file:
		push_error("Invalid sound effect or missing file")
		return

	var path := sfx.sound_file.resource_path

	# Acquire a free player
	var player = _get_player()

	# Assign the imported stream directly
	player.stream = sfx.sound_file
	player.volume_db = linear_to_db(volume)

	player.play()

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
