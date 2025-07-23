class_name RecipeBookOpener extends Node

var recipe_book: RecipeBook = null

static var instance: RecipeBookOpener

func _init() -> void:
	instance = self

func _process(_delta: float) -> void:
	if recipe_book != null: return # while the book menu is open, wait for it to close (free) itself
	
	if Input.is_action_just_pressed("open_recipes"):
		open_book()

func open_book() -> void:
	recipe_book = load("res://menus/recipe_book/recipe_book_view_only.tscn").instantiate()
	recipe_book.user_closable = true
	add_child(recipe_book)
