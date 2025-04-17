extends TextureRect

@export var scroll_position: Vector2
@export var scroll_time := 1.0

@onready var start_pos := position

func _process(delta: float) -> void:
	var seconds = Time.get_ticks_msec() / 1000.0
	position = start_pos + scroll_position * fmod(seconds / scroll_time, 1.0)
