extends Node
class_name SFXPlayer

@export var bus_name: String = "SFX"

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayerA

func _ready():
	pass
# Public method to transition to a song given its string filename `example_song.tres`, for example.
func play_from_id(filename: String, volume: float = 1.0):
	var sfx: AudioStream = SFXScanner.get_effect_by_filename(filename)
	if not sfx:
		return
	play(sfx)

# Public API
func play(sfx: AudioStream) -> void:
	audio_player.stream = sfx
	audio_player.play()

func stop() -> void:
	audio_player.stop()
