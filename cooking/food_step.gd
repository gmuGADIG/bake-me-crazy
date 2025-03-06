extends Control
## Represents a single step in the recipe.
class_name FoodStep

## This function will be called by the FoodMinigame when this step begins.
func start():
	pass
	
signal finished(score: float)
