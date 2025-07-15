extends Node2D

##The amount of distance the mask needs to travel to go from 100% full to 0% full
#@export var piping_mask_travel_delta : float = 285.0
@onready var icing_mask_height : float = $IcingMasks/FullMask.texture.height

##Expects a percentage, between 100.0% and 0.0%, and displays the filling accordingly
func display_icing(percentage_filled : float) -> void:
	var mask_lerp_dist : float = clampf(percentage_filled/100.0,0.0,1.0)
	var mask_texture_size : float = lerpf(icing_mask_height,0,mask_lerp_dist)
	$IcingMasks/FullMask.texture.height = max(mask_texture_size,1)
	
	var offset : float = icing_mask_height-mask_texture_size
	$IcingMasks/FullMask.offset.y = 0.5*offset
	$IcingMasks/FullMask/FadeMask.offset.y = offset
