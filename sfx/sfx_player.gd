extends Node
class_name SFXPlayer

@export var bus_name: String = "SFX"
@export var initial_player_count: int = 3 # Start with a few players in the pool

# Array to track all available audio players
var audio_players: Array[AudioStreamPlayer] = []

# Dictionary to track which players are playing which sound effects
# Format: { stream_filename: player_instance }
var active_sounds: Dictionary = {}

func _ready():
	# Initialize the initial pool of audio players
	for i in range(initial_player_count):
		_create_audio_player()

# Creates a new audio player and adds it to the pool
func _create_audio_player() -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.bus = bus_name
	add_child(player)
	audio_players.append(player)
	
	# Connect to the finished signal to know when a player becomes available
	player.finished.connect(_on_audio_finished.bind(player))
	
	return player

# Called when an audio player finishes playing
func _on_audio_finished(player: AudioStreamPlayer) -> void:
	# Remove this player from the active_sounds dictionary
	for sound_name in active_sounds.keys():
		if active_sounds[sound_name] == player:
			active_sounds.erase(sound_name)
			break

# Find an available audio player or create a new one if necessary
func _get_audio_player() -> AudioStreamPlayer:
	# First, check for any unused players
	for player in audio_players:
		if not player.playing:
			return player
	
	# If no available players, create a new one
	return _create_audio_player()

# Public method to play a sound effect given its string filename
func play_from_id(filename: String, volume: float = 1.0) -> void:
	var sfx: SoundEffect = SFXScanner.get_effect_by_filename(filename)
	if not sfx:
		return
	play(sfx, volume)

# Public API to play a sound effect
func play(sfx: SoundEffect, volume: float = 1.0) -> void:
	if not sfx or not sfx.sound_file:
		push_error("Invalid sound effect or missing sound file")
		return
	
	var stream: AudioStream = sfx.sound_file
	var stream_path = stream.resource_path
	
	# Check if this sound is already playing
	if active_sounds.has(stream_path):
		var current_player = active_sounds[stream_path]
		
		# If the sound is already playing and interrupt is false, do nothing
		if not sfx.interrupt:
			return
		
		# If interrupt is true, stop the current player and start over
		current_player.stop()
		current_player.stream = stream
		current_player.volume_db = linear_to_db(volume)
		current_player.play()
		return
	
	# Get an available player or create a new one
	var player = _get_audio_player()
	
	# Set up the player
	player.stream = stream
	player.volume_db = linear_to_db(volume)
	player.play()
	
	# Mark this sound as active with this player
	active_sounds[stream_path] = player

# Stop a specific sound if it's playing
func stop_sound(sfx: SoundEffect) -> void:
	if not sfx or not sfx.sound_file:
		return
		
	var stream_path = sfx.sound_file.resource_path
	if active_sounds.has(stream_path):
		active_sounds[stream_path].stop()
		active_sounds.erase(stream_path)
		
func stop_by_id(sfx_id: String):
	var sfx: SoundEffect = SFXScanner.get_effect_by_filename(sfx_id)
	if not sfx:
		return
	stop_sound(sfx)

# Stop all sound effects
func stop_all() -> void:
	for player in audio_players:
		player.stop()
	active_sounds.clear()
