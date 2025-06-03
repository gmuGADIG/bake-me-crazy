extends Node

var recipe_book: Node = null

func _process(_delta: float) -> void:
	if recipe_book != null: return # while the book menu is open, wait for it to close (free) itself
	
	if Input.is_action_just_pressed("open_recipes"):
		recipe_book = load("res://menus/recipe_book/recipe_book_view_only.tscn").instantiate()
		add_child(recipe_book)
