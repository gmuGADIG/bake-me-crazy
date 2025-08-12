class_name RecipeBookPage extends Control

@export var food_icon: TextureRect
@export var food_name: Label
@export var food_desc: RichTextLabel
@export var variants: PageVariantList

func display_empty_page() -> void:
	food_icon.texture = null
	food_name.text = "???"
	food_desc.text = "Unlock new recipes by getting to know people more!"
	variants.hide()
	modulate.a = 1.0

func display_recipe(recipe: FoodGroup, is_selected: bool) -> void:
	modulate.a = 0.5 if is_selected else 1.0
	
	food_name.text = recipe.display_name
	food_desc.text = recipe.instructions
	# Find a texture from one of the variants.
	if recipe.variants.is_empty():
		push_error("Recipe doesn't have any variants!")
		variants.hide()
		food_icon.texture = null
		return
	
	food_icon.texture = recipe.variants[0].image
	
	variants.set_variants(recipe.variants)
