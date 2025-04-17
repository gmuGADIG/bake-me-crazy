extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		print('meow')
		SceneTransition.change_scene('res://test_scenes/transitionScene2.tscn')
