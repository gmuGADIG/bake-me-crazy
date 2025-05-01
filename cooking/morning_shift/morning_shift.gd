extends Node

var recipe_book = preload("res://menus/recipe_book/recipe_book.tscn")
var backup_minigame = preload("res://test_scenes/test_food_minigame/test_food_minigame.tscn") 

var variants: Array[RecipeVariant] = []

var current_recipe: RecipeVariant

func _ready() -> void:
	var select_recipe: RecipeBook = recipe_book.instantiate()
	add_child(select_recipe)
	# Godot won't let us use a typed array here. Lame!
	var recipes_selected: Array = await select_recipe.recipes_selected
	while not recipes_selected.is_empty():
		current_recipe = recipes_selected.pop_front()
		
		# Remove current children
		for child in get_children():
			child.queue_free()
			
		var minigame = current_recipe.parent.minigame
		if minigame == null:
			push_error("Recipe ", current_recipe.parent.name, " doesn't have a minigame")
			minigame = backup_minigame
			
		var instance = minigame.instantiate()
		add_child(instance)
		
		# Wait until the food is done.
		await instance.all_minigames_done
		
		# TODO: Here we probably want to show a menu showing the finished food?
		# Then await for that menu being hidden?
	
