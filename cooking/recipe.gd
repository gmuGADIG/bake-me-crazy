extends Resource

class_name Recipe # recipe class

@export var name = ""
@export var food_image: Texture2D
@export_multiline var instructions = ""
@export var is_locked = false

# Check to see if recipes are locked
func is_recipe_locked():
	if (is_locked == true):
		print("oh shoot a recipe")
	else:
		print("recipe is locked")
