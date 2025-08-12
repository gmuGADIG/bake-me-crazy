class_name PageVariant
extends HBoxContainer

@onready var check = preload("res://menus/recipe_book/ingredient_check.png")
@onready var x = preload("res://menus/recipe_book/ingredient_x.png")

func set_variant(variant: FoodData) -> void:
	var can_bake = variant.ingredient == null or Inventory.get_item_count(variant.ingredient) > 0
	
	%Name.text = "• %s" % variant.display_name
	%Check.texture = check if can_bake else x
