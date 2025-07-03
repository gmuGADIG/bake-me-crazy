class_name ButtonHover extends Button

@export var hover_scale := 1.1
@export var pressed_scale := 0.9
@export var duration := 0.3

@onready var original_scale = scale

var lambda: float = 0.0

func _ready() -> void:
	# Compute lambda for correct framerate-independent
	# lerp smoothing. See: https://pbs.twimg.com/media/GGUR6TVWQAATdwe?format=png&name=large
	lambda = -duration / (log(0.01) / log(2))
	
	pivot_offset = size / 2

func _process(delta: float) -> void:
	# NOTE: Kinda sad that we recompute this, ideally it gets cached somewhere.
	var fac := 1.0 - pow(2.0, -delta / lambda)
	var target_scale := 1.0
	if button_pressed:
		target_scale *= pressed_scale
	elif is_hovered():
		target_scale *= hover_scale
	
	scale = lerp(scale, original_scale * target_scale, fac)
