extends Control

func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/clock_out/clock_out.tscn")
