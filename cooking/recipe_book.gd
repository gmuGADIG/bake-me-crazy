extends Control

@export var recipes : Array[Recipe]

var current_page = 0

# Left page of Recipe book
@onready var food_name_left = $"Book/page Left/Food name"
@onready var food_description_left = $"Book/page Left/Food Description"

# Right page of Recipe book
@onready var food_name_right = $"Book/page Right/Food name"
@onready var food_description_right = $"Book/page Right/Food Description"


func _ready() -> void:
	update_displayed_recipes()

func update_displayed_recipes() -> void:
	var left_recipe = recipes[current_page*2]
	var right_recipe = recipes[current_page*2 + 1]
	
	# Shows text on the page
	food_name_left.text = left_recipe.name
	food_description_left.text = left_recipe.instructions
	
	# Shows text on the right page
	food_name_right.text = right_recipe.name
	food_description_right.text = right_recipe.instructions

func _on_left_button_pressed() -> void:
	if current_page <= 0:
		print("You cannot go back from page 1")
	else:
		current_page -= 1
	update_displayed_recipes()

func _on_right_button_pressed() -> void:
	if current_page >= 5:
		print("You cannot go forward from page 12")
	else:
		current_page += 1
	update_displayed_recipes()
