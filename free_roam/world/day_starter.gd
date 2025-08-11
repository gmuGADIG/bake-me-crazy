## Handles the `last_day_started` saved variable, and played the intro timeline on the first day
extends Node

static var last_day_started := 0

@export var intro_timeline: DialogicTimeline

func _init() -> void:
	if last_day_started != PlayerData.data.day:
		last_day_started = PlayerData.data.day
	
		PlayerData.data.day_just_starting = true

func _ready() -> void:
	var game_starting = PlayerData.data.day == 1 and PlayerData.data.day_just_starting

	await get_tree().process_frame
	PlayerData.data.day_just_starting = false

	if game_starting:
		Dialogic.start(intro_timeline)
		print("playing intro narration")
