@tool
extends Control
class_name DayCycle

@onready var sun        := $SunMoon/Sun
@onready var moon       := $SunMoon/Moon
@onready var skyline    := $Skyline
@onready var background := $Background


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sun.global_rotation = 0
	moon.global_rotation = 0
	
	var color: Color = background.color
	color.s -= 0.3
	skyline.modulate = color
