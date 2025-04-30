extends Node

@export var song_name: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainMusicPlayer.transition_to_song_by_filename(song_name)
