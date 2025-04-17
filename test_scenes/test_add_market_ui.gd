extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_page_down"):
		# Instead of loading a UI, simply reload the current scene to test
		# that the is_mid_interaction() logic works.
		SceneTransition.change_scene("res://free_roam/world/streets/streets.tscn")
