extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = get_tree().paused;
		get_tree().paused = not get_tree().paused;
		
func _on_save_game_pressed() -> void:
	$GameSavedIcon.visible = true;
	


func _on_close_menu_pressed() -> void:
	get_tree().paused = not get_tree().paused;
	visible = false;


func _on_return_main_menu_pressed() -> void:
	print("Returned to main menu");


func _on_options_pressed() -> void:
	print("Options Pressed");
