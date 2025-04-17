extends Node2D

@export var target_scene: PackedScene = null

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		print('meow')
		SceneTransition.change_scene_to_packed(target_scene)
