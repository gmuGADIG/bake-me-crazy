class_name RecipeBook extends CanvasLayer

## True during the morning shift, when the player has to select some recipes to bake.
## False if the player is just browsing their recipes whenever.
## The 'Bake' buttons and certain text is only visible when this is true.
@export var allow_baking := true

## True if the user can close the recipe book when the player presses R or esc.
@export var user_closable := true

@onready var page_left: RecipeBookPage = %PageLeft
@onready var page_right: RecipeBookPage = %PageRight
@onready var bake_left: Button = %BakeLeft
@onready var bake_right: Button = %BakeRight
@onready var baking_text: Control = %BakingText
@onready var finish_button: Button = %FinishButton
@onready var turn_page_left: Button = %TurnPageLeft
@onready var turn_page_right: Button = %TurnPageRight
@onready var anim: AnimationPlayer = %Anim

#@onready var debug_all_recipes = [
	#"res://items/recipes/bar.tres",
	#"res://items/recipes/bread.tres",
	#"res://items/recipes/brownie.tres",
	#"res://items/recipes/cake.tres",
	#"res://items/recipes/cannelle.tres",
	#"res://items/recipes/cookie.tres",
	#"res://items/recipes/croissant.tres",
	#"res://items/recipes/food_group.gd",
	#"res://items/recipes/macaron.tres",
	#"res://items/recipes/puff_roll.tres",
	#"res://items/recipes/scone.tres",
	#"res://items/recipes/sweet_roll.tres",
	#"res://items/recipes/tart.tres",
#]

var recipes : Array[FoodGroup]

var current_page = 0
var selected_recipes: Array[int] = [] ## List of indices that have been selected to bake

signal recipes_selected(variants: Array[FoodData])

func _ready() -> void:
	get_tree().paused = true # this is reset to false in _on_tree_exiting
	MainMusicPlayer.set_volume(0.3)

	#for recipe_path in debug_all_recipes:
	for recipe_path in PlayerData.data.unlocked_recipe_paths:
		recipes.append(load(recipe_path))
	update_displayed_recipes()
	
	if not allow_baking:
		bake_left.visible = false
		bake_right.visible = false
		baking_text.visible = false
		
	if user_closable:
		%BakeLeft.hide()
		%BakeRight.hide()
		$CountertopBlue.hide()
		%ReadOnlyOpenAnimation.play("new_animation")
		
		# the first frame will flicker because animation player sux
		# so we hide the first frame so the player wont see a flicker
		hide()
		await get_tree().process_frame
		show()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") || Input.is_action_just_pressed("open_recipes"):
		if user_closable: 
			%ReadOnlyOpenAnimation.play_backwards("new_animation")
			await %ReadOnlyOpenAnimation.animation_finished
			queue_free()

func update_displayed_recipes() -> void:
	var left_idx = current_page*2
	var right_idx = left_idx + 1
	if left_idx < recipes.size():
		page_left.display_recipe(recipes[left_idx], left_idx in selected_recipes)
		bake_left.visible = true
	else:
		page_left.display_empty_page()
		bake_left.visible = false
	
	if right_idx < recipes.size():
		page_right.display_recipe(recipes[right_idx], right_idx in selected_recipes)
		bake_right.visible = true
	else:
		page_right.display_empty_page()
		bake_right.visible = false
	
	#var max_page = (recipes.size() - 1) / 2
	var max_page = 12
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
	anim.stop()
	anim.play("flip_left")

func _on_turn_page_right_pressed() -> void:
	current_page += 1
	update_displayed_recipes()
	anim.stop()
	anim.play("flip_right")

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
	var first : FoodGroup = recipes[selected_recipes[0]]
	var second: FoodGroup = recipes[selected_recipes[1]]
	%RecipeVariantSelection.show_variants(first, second)
	
	# TODO: Move this to the new variant selection menu?
	#
func _on_tree_exiting() -> void:
	get_tree().paused = false
	MainMusicPlayer.set_volume(1.0)
