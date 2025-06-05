class_name Scroller extends Control

@export var started := false
@export var scroll_speed := 50.

func _process(delta: float) -> void:
	if not started: return
	position.y -= scroll_speed * delta
