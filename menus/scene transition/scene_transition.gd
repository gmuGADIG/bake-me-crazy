extends CanvasLayer

var targetScenePath = ""

func move_to_scene() -> void:
	get_tree().change_scene_to_file(targetScenePath)

#call this function to move the scene!
#SceneTransition.change_scene(pathtoscene)
func change_scene(targetScene) -> void:
	targetScenePath = targetScene
	$AnimationPlayer.play("swipe")
	
