extends Node2D

@export var mask_travel_delta : float = -91.86

##Expects a percentage, between 0.0% and 0.0%, and displays the filling accordingly
func display_filling(percentage_filled : float) -> void:
	var mask_lerp_dist : float = clampf((percentage_filled)/100.0,0.0,1.0)
	var scale_size : float = lerpf(0,mask_travel_delta,mask_lerp_dist)
	$FillingMask.scale = Vector2(scale_size,scale_size)
