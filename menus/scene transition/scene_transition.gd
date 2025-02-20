extends CanvasLayer

@export var targetScenePath = ""

func move_to_scene(target: String) -> void:
	get_tree().change_scene_to_file(targetScenePath)
	
#call this function to move the scene!
func change_scene() -> void:
	$AnimationPlayer.play("swipe")
	$AnimationPlayer.play("RESET")
