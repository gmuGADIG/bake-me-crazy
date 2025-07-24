class_name DrizzleLine extends Node2D

const GRAVITY := 280.

@onready var line_template: Line2D = $Line2D

var lines: Array[Line2D]
var durations: Array[Array] = []

func _ready():
	remove_child(line_template)

func _physics_process(delta: float) -> void:
	for line_index in lines.size():
		var line := lines[line_index]
		var new_points := line.points
		
		for index in new_points.size():
			if durations[line_index][index] > 0:
				durations[line_index][index] -= delta
				new_points[index].y += GRAVITY * delta
		
		line.points = new_points

func clear_points():
	for line in lines:
		line.queue_free()
	lines.clear()
	durations.clear()

func add_point(pos: Vector2, fall_duration: float, new_line: bool):
	if not new_line:
		lines[-1].add_point(pos)
		durations[-1].push_back(fall_duration)
	else:
		lines.push_back(line_template.duplicate())
		add_child(lines[-1])
		durations.push_back([])
		add_point(pos, fall_duration, false)

func _exit_tree() -> void:
	line_template.queue_free()
