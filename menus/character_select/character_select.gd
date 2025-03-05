class_name CharSelect extends Control

## A number from 0 to 5 representing the currently selected character. Defaults to zero.
var selected_character: int

@onready var button_container: HBoxContainer = $ButtonHBoxContainer

func _ready() -> void:
	for button in button_container.get_children():
		button.pressed.connect(
			func(): select_character(button.char_id)
		)

func select_character(char_id: int) -> void:
	selected_character = char_id
	print("selected character: ", selected_character)
	# TODO: when a character is selected, go to a new scene
