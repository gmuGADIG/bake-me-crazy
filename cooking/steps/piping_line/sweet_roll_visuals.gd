extends Node2D

##The amount the mask needs to scale up to reach 100% mask
@export var glazing_scale_delta : float = 2.0

##Expects a percentage, between 0.0% and 0.0%, and displays the filling accordingly
func display_icing(percentage_glazed : float) -> void:
	var mask_lerp_dist : float = clampf((percentage_glazed)/100.0,0.0,1.0)
	var scale_size : float = lerpf(0,glazing_scale_delta,mask_lerp_dist)
	$GlazeMask.scale = Vector2(scale_size,scale_size)
