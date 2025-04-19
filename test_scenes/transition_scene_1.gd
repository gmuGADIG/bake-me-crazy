extends Node2D

@export var target_scene: String = ""

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		print('meow')
		SceneTransition.change_scene_to_file(target_scene)
