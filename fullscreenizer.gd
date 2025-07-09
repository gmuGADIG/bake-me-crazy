extends Node

# TODO: store fullscreen state in aux save data

const FULLSCREEN_MODE: Window.Mode = Window.MODE_EXCLUSIVE_FULLSCREEN

func _process(_delta: float):
	if Input.is_action_just_pressed("fullscreen"):
		if get_window().mode == FULLSCREEN_MODE:
			get_window().mode = Window.MODE_WINDOWED
		else:
			get_window().mode = FULLSCREEN_MODE
