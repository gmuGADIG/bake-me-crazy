extends Control

var time_passed := 0.0

@export var wiggle_degrees: float
@export var wiggle_speed_mult: float
@export var wiggle_offset: float

func _process(delta: float) -> void:
	time_passed += delta
	var button_containers = get_tree().get_nodes_in_group("button_container")
	for i in range(button_containers.size()):
		var button_container = button_containers[i]
		var button = button_container.get_child(0) as Button
		assert(button != null)
		
		var offset = i * wiggle_offset  # Slight phase shift for each button
		button.rotation_degrees = sin(time_passed * wiggle_speed_mult + offset) * wiggle_degrees  # Wiggle effect

func _on_start_pressed() -> void:
	#SceneTransition.change_scene_to_file("res://menus/character_select/character_select.tscn")
	PlayerData.reset()
	SceneTransition.change_scene_to_file("res://free_roam/world/streets/streets.tscn")

func _on_load_game_pressed() -> void:
	var saves_menu = load("res://menus/save_menu/save_menu.tscn").instantiate()
	saves_menu.can_save = false
	add_child(saves_menu)

func _on_options_pressed() -> void:
	var settings_menu: Node = load("res://menus/settings/settings_menu.tscn").instantiate()
	add_child(settings_menu)

func _on_credits_pressed() -> void:
	SceneTransition.change_scene_to_file("res://credits/credits.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
