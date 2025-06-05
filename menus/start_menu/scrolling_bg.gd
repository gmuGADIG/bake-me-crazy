class_name ScrollingBackground extends TextureRect

@export var unique := false
@export var started := true:
	set(v):
		started = v
		start_time = Time.get_ticks_msec()
@export var scroll_position: Vector2
@export var scroll_time := 1.0

@onready var start_pos := position

var start_time: int = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if not started: return
	var millis = Time.get_ticks_msec() - start_time if unique else Time.get_ticks_msec()
	var seconds = millis / 1000.
	position = start_pos + scroll_position * fmod(seconds / scroll_time, 1.0)
