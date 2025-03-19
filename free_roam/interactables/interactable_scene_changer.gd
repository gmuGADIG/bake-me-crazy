extends Interactable

@export var change_to_scene: PackedScene

func _interact() -> void:
	get_tree().change_scene_to_packed(change_to_scene)
