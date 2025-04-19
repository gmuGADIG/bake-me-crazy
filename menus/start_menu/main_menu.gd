extends Control

var time_passed := 0.0

@export var wiggle_degrees: float
@export var wiggle_speed_mult: float
@export var wiggle_offset: float

func _process(delta: float) -> void:
	time_passed += delta
	for i in range($VBoxContainer.get_child_count()):
		var button_container = $VBoxContainer.get_child(i) as Control
		var button = button_container.get_child(0) as Button
		assert(button != null)
		
		var offset = i * wiggle_offset  # Slight phase shift for each button
		button.rotation_degrees = sin(time_passed * wiggle_speed_mult + offset) * wiggle_degrees  # Wiggle effect

func _on_start_pressed() -> void:
	SceneTransition.change_scene_to_file("res://menus/character_select/character_select.tscn")

func _on_load_game_pressed() -> void:
	var saves_menu = load("res://menus/save_menu/save_menu.tscn").instantiate()
	saves_menu.can_save = false
	add_child(saves_menu)

func _on_options_pressed() -> void:
	var settings_menu: Node = load("res://menus/settings/settings_menu.tscn").instantiate()
	add_child(settings_menu)

func _on_credits_pressed() -> void:
	print("GADIG made this game") # Temporary code

func _on_quit_game_pressed() -> void:
	get_tree().quit()
