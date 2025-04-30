extends Node2D

var recipe_book = preload("res://menus/recipe_book/recipe_book.tscn")
var food_minigame = preload("res://test_scenes/test_food_minigame/test_food_minigame.tscn") 

func _ready() -> void:
	var select_recipe: RecipeBook = recipe_book.instantiate()
	add_child(select_recipe)
	var recipes_selected = await select_recipe.recipes_selected
	select_recipe.queue_free()
	var play_minigame = food_minigame.instantiate()
	add_child(play_minigame)
