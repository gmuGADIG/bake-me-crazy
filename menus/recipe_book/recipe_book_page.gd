class_name RecipeBookPage extends Panel

@onready var food_icon: TextureRect = %FoodIcon
@onready var food_name: Label = %FoodName
@onready var food_desc: Label = %FoodDesc

@onready var variants_left = %FoodVariantsLeft
@onready var variants_right = %FoodVariantsRight

func populate_variant(idx: int, text: String) -> void:
	var column: Label = variants_left if idx % 2 == 0 else variants_right
	column.text += str("- ", text, "\n")

func display_recipe(recipe: FoodGroup, is_selected: bool) -> void:
	food_name.text = recipe.display_name
	food_desc.text = recipe.instructions
	# Find a texture from one of the variants.
	if recipe.variants.is_empty():
		push_error("Recipe doesn't have any variants!")
		return
	food_icon.texture = recipe.variants[0].image
	
	variants_left.text = ""
	variants_right.text = ""
	for i in range(0, recipe.variants.size()):
		populate_variant(i, recipe.variants[i].display_name)
	
	modulate.a = 0.5 if is_selected else 1.0
