extends Control

func _on_proceed_button_pressed() -> void:
	SceneTransition.change_scene_to_file("res://menus/clock_out/clock_out.tscn")
