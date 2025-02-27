extends Node2D
var holding: bool = false

#Used to see wether or not the player is "holding" an object
#Used to make sure the player is only dragging one at a time

func _set_holding(new_value: bool) -> void:
	holding = new_value
	
func _get_holding() -> bool:
	return holding
