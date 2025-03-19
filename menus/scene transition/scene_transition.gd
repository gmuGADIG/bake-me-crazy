extends CanvasLayer

var targetScenePath = ""

func move_to_scene() -> void:
	print('im like hey whats up hello')
	get_tree().change_scene_to_file(targetScenePath)

#call this function to move the scene!
func change_scene(targetScene) -> void:
	targetScenePath = targetScene
	$AnimationPlayer.play("swipe")
	
