extends ColorRect
class_name RecipeVariantSelection

@onready var variants_left  := %VariantsLeft
@onready var variants_right := %VariantsRight

@onready var select_for_left  := $SelectForLeft
@onready var select_for_right := $SelectForRight

@onready var confirm_button := $ConfirmButton

var button_group_left : ButtonGroup = null
var button_group_right: ButtonGroup = null

func _ready():
	hide()
	
## Recomputes whether the confirm button can be pressed. It can only be pressed
## if both ButtonGroups have a selected button.
func _update_confirm_button() -> void:
	var enabled = true
	if button_group_left.get_pressed_button() == null:
		enabled = false
	if button_group_right.get_pressed_button() == null:
		enabled = false
	confirm_button.disabled = not enabled

func populate(container: VBoxContainer, recipe: Recipe) -> ButtonGroup:
	# Clear existing children	
	for child in container.get_children():
		child.queue_free()
		
	var button_group: ButtonGroup = ButtonGroup.new()
	var has_selected_button = false
		
	for variant in recipe.variants:
		var button := preload("res://menus/recipe_book/recipe_book_variant_button.tscn")\
			.instantiate()
		button.variant = variant
		button.button_group = button_group
		container.add_child(button)
		
		# Automatically select one of the variants when possible so
		# that the user can immediately move on if they want.
		if not button.disabled and not has_selected_button:
			button.button_pressed = true
			has_selected_button = true
			
	return button_group

func show_variants(recipe1: Recipe, recipe2: Recipe):
	button_group_left  = populate(variants_left , recipe1)
	button_group_right = populate(variants_right, recipe2)
	select_for_left.text  = "Select variant for " + recipe1.name
	select_for_right.text = "Select variant for " + recipe2.name
	_update_confirm_button()
	show()
