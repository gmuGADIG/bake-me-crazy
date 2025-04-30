extends Interactable

@export var change_to_scene: PackedScene

func _interact() -> void:
	SceneTransition.change_scene_to_packed(change_to_scene)
