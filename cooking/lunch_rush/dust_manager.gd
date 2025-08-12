class_name DustManager
extends Node

const EPSILON := 0.001

@onready var parent: Sprite2D = get_parent()
@onready var texture: NoiseTexture2D = parent.texture
#@onready var gradient := texture.color_ramp

@onready var position := 0.:
	set(v):
		position = clampf(v, 0., 2.)
		_update_gradient()

func _update_gradient() -> void:
	var gradient := Gradient.new()
	gradient.set_color(0, Color.TRANSPARENT)
	gradient.set_color(1, Color.WHITE)
	
	if position < 1.:
		var stop_pos := remap(position, 0., 1., 1. - EPSILON, 0.)
		gradient.set_offset(0, stop_pos)
		gradient.set_offset(1, 1.)
	else:
		var stop_pos := remap(position, 1., 2., 1., EPSILON)
		gradient.set_offset(0, 0.)
		gradient.set_offset(1, stop_pos)
	
	texture.color_ramp = gradient
