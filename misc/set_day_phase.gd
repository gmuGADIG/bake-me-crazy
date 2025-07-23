extends Node

@export var new_day_phase: SaveTemplate.DayPhase

func _ready() -> void:
	PlayerData.data.day_phase = new_day_phase
