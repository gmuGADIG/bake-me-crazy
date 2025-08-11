class_name CharSelect extends Control

@onready var button_container: HBoxContainer = $ButtonHBoxContainer

func _ready() -> void:
	for button in button_container.get_children():
		button.pressed.connect(
			func(): select_character(button.char_id)
		)

func select_character(char_id: int) -> void:
	print("selected character: ", char_id)
	PlayerData.data.selected_character = char_id
	SceneTransition.change_scene_to_file("res://free_roam/world/farmers_market/farmers_market.tscn")
