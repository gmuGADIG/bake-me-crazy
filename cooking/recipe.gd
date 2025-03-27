extends Resource

class_name Recipe # recipe class

@export var name = ""
@export var ingredients = {}
@export var is_locked = false

# Check to see if recipes are locked
func is_recipe_locked():
	if (is_locked == true):
		print("oh shoot a recipe")
	else:
		print("recipe is locked")
