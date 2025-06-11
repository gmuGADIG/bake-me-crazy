extends Button
class_name RecipeBookVariantButton

var variant: FoodData

@onready var food_texture := %FoodTexture
@onready var variant_name := %VariantName
@onready var requirement_name := %RequirementName
@onready var quantity_requirement := %QuantityRequirement

func _ready() -> void:
	if variant == null:
		push_warning("Recipe book variant button had null variant!")
		return

	# If we don't have a requirement, we're always available, and
	# we can make our requirement name "Nothing!"
	if variant.ingredient == null:
		requirement_name.text = "Nothing!"
		quantity_requirement.hide()
	else:
		# TODO: Look this up through the item system
		var actual_requirement_name = variant.ingredient.display_name
		# TODO: Look this up through the inventory system
		var we_have: int = Inventory.get_item_count(variant.ingredient)

		requirement_name.text = actual_requirement_name
		quantity_requirement.text = str(we_have, "/1")
		
		# Disable this button if we don't meet the requirement.
		disabled = we_have == 0
		
	# Set the image & the text on each field.	
	food_texture.texture = variant.image
	variant_name.text = variant.display_name
