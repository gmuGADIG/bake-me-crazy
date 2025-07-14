extends Node2D

##The amount of distance the mask needs to travel to go from 100% full to 0% full
@export var piping_mask_travel_delta : float = 285.0

##Expects a percentage, between 100.0% and 0.0%, and displays the filling accordingly
func display_icing(percentage_filled : float) -> void:
	var mask_travel_dist : float = clampf((100.0-percentage_filled)/100.0,0.0,1.0)
	$IcingMask.offset.y = lerpf(0,piping_mask_travel_delta,mask_travel_dist)
