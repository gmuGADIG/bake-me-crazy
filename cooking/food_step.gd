extends Control
## Represents a single step in the recipe.
class_name FoodStep
## This step will be called by the FoodMinigame before the animation for this
## step.
func pre_animation():
	pass

## This function will be called by the FoodMinigame when this step begins.
func start():
	pass
	
signal finished(score: float)
