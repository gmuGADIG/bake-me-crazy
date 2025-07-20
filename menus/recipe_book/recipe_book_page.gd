class_name RecipeBookPage extends Control

@export var food_icon: TextureRect
@export var food_name: Label
@export var food_desc: RichTextLabel
@export var variants: RichTextLabel

func display_empty_page() -> void:
	food_icon.texture = null
	food_name.text = "???"
	food_desc.text = "Unlock new recipes by getting to know people more!"
	variants.text = ""
	modulate.a = 1.0

func display_recipe(recipe: FoodGroup, is_selected: bool) -> void:
	modulate.a = 0.5 if is_selected else 1.0
	
	food_name.text = recipe.display_name
	food_desc.text = recipe.instructions
	# Find a texture from one of the variants.
	if recipe.variants.is_empty():
		push_error("Recipe doesn't have any variants!")
		variants.text = ""
		food_icon.texture = null
		return
	
	food_icon.texture = recipe.variants[0].image
	
	variants.text = "Variants\n"
	for variant in recipe.variants:
		var can_bake = variant.ingredient == null or Inventory.get_item_count(variant.ingredient) > 0
		var check_str = "[color=#2cb020]✓[/color]" if can_bake else "[color=#b02022]✗[/color]"
		variants.text += "• %s [b]%s[/b]\n" % [variant.display_name, check_str]
	
