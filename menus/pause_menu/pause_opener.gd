extends Control

var is_paused: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if is_paused is false and escaped is pressed, creates the pause menu, sets is_paused to true
	#this requires in the pause script that once the pause scene no longer active, that the bool returns false
	#It may also require, that the pause is changed so that when it is disabled, that it destroys itself
	
	
	if Input.is_action_just_pressed("pause") and not is_paused:
		var pausescreen = load("res://menus/pause_menu/pause_menu_scene.tscn").instantiate()
		add_child(pausescreen)
		is_paused = true
		
		
	pass
