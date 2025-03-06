extends Control

func _process(_delta: float) -> void:
	#Checks if the player just pressed the input action labeled "pause" 
	#(which is usually defined in the Input Map in Project Settings)
	if Input.is_action_just_pressed("pause"):
		$PauseContainer.visible = get_tree().paused;
		get_tree().paused = not get_tree().paused;
		
func _on_save_game_pressed() -> void:
	$GameSavedIcon.visible = true;
	


func _on_close_menu_pressed() -> void:
	get_tree().paused = not get_tree().paused;
	$PauseContainer.visible = false;


func _on_return_main_menu_pressed() -> void:
	$ConfirmQuitContainer.visible = true;
	$PauseContainer.visible = false;


func _on_options_pressed() -> void:
	print("Options Pressed");


func _on_confirm_quit_pressed() -> void:
	print("Game Close");


func _on_return_pause_pressed() -> void:
	$PauseContainer.visible = true;
	$ConfirmQuitContainer.visible = false;
