extends ColorRect
class_name RecipeVariantSelection

@onready var variants_left  := %VariantsLeft
@onready var variants_right := %VariantsRight

func _ready():
	hide()

func populate(container: VBoxContainer, recipe: Recipe):
	# Clear existing children	
	for child in container.get_children():
		child.queue_free()
		
	for variant in recipe.variants:
		var button := preload("res://menus/recipe_book/recipe_book_variant_button.tscn")\
			.instantiate()
		button.variant = variant
		container.add_child(button)

func show_variants(recipe1: Recipe, recipe2: Recipe):
	populate(variants_left , recipe1)
	populate(variants_right, recipe2)
	show()
