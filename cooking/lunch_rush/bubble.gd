extends Sprite2D

@onready var base_scale := scale
@onready var base_angle := rotation_degrees
@onready var t = randf_range(0, 2 * PI)

@export_range(0, 1) var stretch_strength := .05
@export_range(0, 5) var stretch_speed := 1.0
@export_range(0, 90) var rotation_angles := 5
@export_range(0, 5) var rotation_speed := 0.5

func _process(delta: float) -> void:
	t += delta
	
	# scale
	var x = 1 + sin(t * stretch_speed) * stretch_strength
	var y = 1.0 / x
	scale = scale.move_toward(base_scale * Vector2(x, y), delta)

	# rotation
	rotation_degrees = base_angle + sin(t * rotation_speed) * rotation_angles
