extends Button
class_name RecipeBookVariantButton

var variant: RecipeVariant

@onready var food_texture := %FoodTexture
@onready var variant_name := %VariantName
@onready var requirement_name := %RequirementName
@onready var quantity_requirement := %QuantityRequirement

func _ready() -> void:
	if variant == null:
		push_warning("Recipe book variant button had null variant!")
		
		# Set up a dummy RecipeVariant for testing purposes.
		variant = RecipeVariant.new()
		variant.key_ingredient = preload("res://items/ingredients/chocolate.tres")
		variant.key_ingredient_requirement = 3
		variant.name = "Chocolate"
		variant.texture = preload("res://items/foods/art/Cake_Chocolate.png")
	# If we don't have a requirement, we're always available, and
	# we can make our requirement name "Nothing!"
	if variant.key_ingredient_requirement <= 0 or variant.key_ingredient == null:
		requirement_name.text = "Nothing!"
		quantity_requirement.hide()
	else:
		# TODO: Look this up through the item system
		var actual_requirement_name = variant.key_ingredient.display_name
		# TODO: Look this up through the inventory system
		var we_have: int = Inventory.get_item_count(variant.key_ingredient)

		requirement_name.text = actual_requirement_name
		quantity_requirement.text = str(we_have, "/", variant.key_ingredient_requirement)
		
		# Disable this button if we don't meet the requirement.
		disabled = variant.key_ingredient_requirement > we_have
		
	# Set the image & the text on each field.	
	food_texture.texture = variant.texture
	variant_name.text = variant.name
