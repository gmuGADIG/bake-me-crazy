extends Button
class_name RecipeBookVariantButton

var variant: RecipeVariant

@onready var food_texture := %FoodTexture
@onready var variant_name := %VariantName
@onready var requirement_name := %RequirementName
@onready var quantity_requirement := %QuantityRequirement

func _ready() -> void:
	if variant == null:
		push_error("Recipe book variant button had null variant!")
		
		# Set up a dummy RecipeVariant for testing purposes.
		variant = RecipeVariant.new()
		variant.key_ingredient = "chocolate"
		variant.key_ingredient_requirement = 3
		variant.name = "Chocolate"
		variant.texture = preload("res://recipes/Cake_Chocolate.png")
	# If we don't have a requirement, we're always available, and
	# we can make our requirement name "Nothing!"
	if variant.key_ingredient_requirement <= 0 or variant.key_ingredient == null:
		requirement_name.text = "Nothing!"
		quantity_requirement.hide()
	else:
		# TODO: Look this up through the item system
		var actual_name = "Ingredient Name"
		# TODO: Look this up through the inventory system
		var we_have: int = 5
		
		quantity_requirement.text = str(we_have, "/", variant.key_ingredient_requirement)
		# Disable this button if we don't meet the requirement.
		disabled = variant.key_ingredient_requirement > we_have
