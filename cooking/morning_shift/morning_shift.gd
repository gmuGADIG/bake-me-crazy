class_name MorningShift
extends Node

static var instance: MorningShift

var recipe_book = preload("res://menus/recipe_book/recipe_book.tscn")
var backup_minigame = load("res://test_scenes/test_food_minigame/test_food_minigame.tscn") 

var variants: Array[FoodData] = []

var current_step: int = 1
var current_recipe: FoodData

func _init() -> void:
	instance = self

func _ready() -> void:
	var select_recipe: RecipeBook = recipe_book.instantiate()
	select_recipe.user_closable = false
	add_child(select_recipe)
	# Godot won't let us use a typed array here. Lame!
	var recipes_selected: Array = await select_recipe.recipes_selected
	while not recipes_selected.is_empty():
		current_recipe = recipes_selected.pop_front()
		current_step = 1
		
		# Remove current children (excluding pause opener)
		for child in get_children():
			if child is not PauseOpener:
				child.queue_free()
			
		var minigame = current_recipe.cooking_minigame
		if minigame == null:
			push_error("Food ", current_recipe.display_name, " doesn't have a minigame")
			minigame = backup_minigame
			
		var instance = minigame.instantiate()
		add_child(instance)
		
		# Wait until the food is done.
		await instance.all_minigames_done
		
		# TODO: Here we probably want to show a menu showing the finished food?
		# Then await for that menu being hidden?
		
	# Once we reach here, we have awaited for all the sub-menus, and are ready
	# to move on to the next step.
	# According to what I can find, this is the lunch break?
	SceneTransition.change_scene_to_file("res://free_roam/world/lunch_break/lunch_break.tscn")
	
