class_name RecipeBook extends Node

## True during the morning shift, when the player has to select some recipes to bake.
## False if the player is just browsing their recipes whenever.
## The 'Bake' buttons and certain text is only visible when this is true.
@export var allow_baking := true

## True if the user can close the recipe book when the player presses R or esc.
@export var user_closable := true

@export var recipes : Array[Recipe]

@onready var page_left: RecipeBookPage = %PageLeft
@onready var page_right: RecipeBookPage = %PageRight
@onready var bake_left: Button = %BakeLeft
@onready var bake_right: Button = %BakeRight
@onready var baking_text: Control = %BakingText
@onready var finish_button: Button = %FinishButton
@onready var turn_page_left: Button = %TurnPageLeft
@onready var turn_page_right: Button = %TurnPageRight

var current_page = 0
var selected_recipes: Array[int] = [] ## List of indices that have been selected to bake

signal recipes_selected(variants: Array[RecipeVariant])

func _ready() -> void:
	get_tree().paused = true # this is reset to false in _on_tree_exiting
	MainMusicPlayer.set_volume(0.3)
	update_displayed_recipes()
	
	if not allow_baking:
		bake_left.visible = false
		bake_right.visible = false
		baking_text.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") || Input.is_action_just_pressed("open_recipes"):
		if user_closable: queue_free()

func update_displayed_recipes() -> void:
	var left_idx = current_page*2
	var right_idx = left_idx + 1
	page_left.display_recipe(recipes[left_idx], left_idx in selected_recipes)
	page_right.display_recipe(recipes[right_idx], right_idx in selected_recipes)
	
	var max_page = (recipes.size() / 2) - 1
	turn_page_left.disabled  = current_page <= 0
	turn_page_right.disabled = current_page >= max_page
	
	if selected_recipes.size() < 2:
		finish_button.text = "%d/2 Recipes Selected" % selected_recipes.size()
		finish_button.disabled = true
	elif selected_recipes.size() == 2:
		finish_button.text = "Done!"
		finish_button.disabled = false
	else:
		finish_button.text = "Too Many Selected!"
		finish_button.disabled = true

func _on_turn_page_left_pressed() -> void:
	current_page -= 1
	update_displayed_recipes()

func _on_turn_page_right_pressed() -> void:
	current_page += 1
	update_displayed_recipes()

func _on_bake_left_pressed() -> void:
	_toggle_recipe_selection(current_page*2)

func _on_bake_right_pressed() -> void:
	_toggle_recipe_selection(current_page*2 + 1)

func _toggle_recipe_selection(recipe_idx: int) -> void:
	var found = selected_recipes.find(recipe_idx)
	if found == -1: # add recipe to selection
		selected_recipes.append(recipe_idx)
	else: # recipe has already been selected; remove it from selection
		selected_recipes.remove_at(found)
	
	update_displayed_recipes()

func _on_finish_button_pressed() -> void:
	# Load the variant selection at this time.
	var first : Recipe = recipes[selected_recipes[0]]
	var second: Recipe = recipes[selected_recipes[1]]
	%RecipeVariantSelection.show_variants(first, second)
	
	# TODO: Move this to the new variant selection menu?
	#
func _on_tree_exiting() -> void:
	get_tree().paused = false
	MainMusicPlayer.set_volume(1.0)
