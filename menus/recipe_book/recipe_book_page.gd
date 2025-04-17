class_name RecipeBookPage extends Panel

@onready var food_icon: TextureRect = %FoodIcon
@onready var food_name: Label = %FoodName
@onready var food_desc: Label = %FoodDesc

func display_recipe(recipe: Recipe, is_selected: bool) -> void:
	food_name.text = recipe.name
	food_desc.text = recipe.instructions
	food_icon.texture = recipe.food_image
	
	modulate.a = 0.5 if is_selected else 1.0
