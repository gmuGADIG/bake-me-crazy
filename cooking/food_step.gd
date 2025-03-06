extends Control
## Represents a single step in the recipe.
class_name FoodStep

## Adds a new ingredient to the scene.
##
## TODO: This should probably take something other than a Texture2D.
func add_ingredient(tex: Texture2D) -> FoodItem:
	var ingredient := FoodItem.create_textured_food(tex)
	
	add_child(ingredient)
	
	return ingredient

## This function will be called by the FoodMinigame when this step begins.
func start():
	pass
	
signal finished(score: float, kept_item: FoodItem)
