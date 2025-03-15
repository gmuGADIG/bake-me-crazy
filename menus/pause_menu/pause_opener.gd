extends Node

var pause_menu: Node = null

func _process(_delta: float) -> void:
	if pause_menu != null: return # while the pause menu is open, wait for it to close (free) itself
	
	if Input.is_action_just_pressed("pause"):
		pause_menu = load("res://menus/pause_menu/pause_menu_scene.tscn").instantiate()
		add_child(pause_menu)
