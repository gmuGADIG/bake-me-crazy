class_name CharSelect extends Control

@onready var button_container: HBoxContainer = $ButtonHBoxContainer

func _ready() -> void:
	for button in button_container.get_children():
		button.pressed.connect(
			func(): select_character(button.char_id)
		)

func select_character(char_id: int) -> void:
	PlayerData.data.selected_character = char_id
	print("selected character: ", char_id)
	# TODO: when a character is selected, go to a new scene
