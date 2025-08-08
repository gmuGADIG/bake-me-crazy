extends Node2D

func _ready() -> void:
	Dialogic.start(load("res://dialogue/narration/festival_start.dtl"))
