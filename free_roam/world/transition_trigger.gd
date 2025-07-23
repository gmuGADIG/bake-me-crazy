extends Area2D

@export var target_scene_path: String


func _on_area_entered(area: Area2D) -> void:
	SceneTransition.change_scene_to_file(target_scene_path, true)
