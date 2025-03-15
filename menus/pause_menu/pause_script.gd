extends CanvasLayer

func _ready() -> void:
	get_tree().paused = true # this is reset to false in _on_tree_exiting

func _process(_delta: float) -> void:
	# close when the player presses "pause" again
	if Input.is_action_just_pressed("pause"):
		queue_free()

func _on_tree_exiting() -> void:
	get_tree().paused = false

func _on_save_game_pressed() -> void:
	$GameSavedIcon.visible = true
	print("TODO: save game")

func _on_load_game_pressed() -> void:
	print("TODO: load game")

func _on_close_menu_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_return_main_menu_pressed() -> void:
	print("TODO: go to main menu")

func _on_options_pressed() -> void:
	print("TODO: open options")

func _on_confirm_quit_pressed() -> void:
	print("TODO: return to main menu")

func _on_return_pause_pressed() -> void:
	$PauseContainer.visible = true
	$ConfirmQuitContainer.visible = false
