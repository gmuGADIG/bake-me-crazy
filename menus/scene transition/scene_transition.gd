extends CanvasLayer
## The script for the SceneTransition autoload.
class_name SceneTransitionScript # class_name can't be exactly 'SceneTransition'

## Stores the scene that we are going to change to.
var _next_scene: PackedScene = null

func _ready() -> void:
	# Make sure that we will always be able to transition, even while paused.
	process_mode = PROCESS_MODE_ALWAYS

func is_transitioning() -> bool:
	return $AnimationPlayer.is_playing()

## Called by the AnimationPlayer when the swipe animation is ready to actually
## change to the next scene.
func _anim_move_to_scene() -> void:
	get_tree().change_scene_to_packed(_next_scene)
	_next_scene = null

## Call this to change the scene to a scene at a specific path,
## similar to get_tree().change_scene_to_file.
func change_scene_to_file(file_path: String, fade_to_black: bool = false) -> void:
	change_scene_to_packed(load(file_path), fade_to_black)

## Call this to change the scene to a specific PackedScene value,
## similar to get_tree().change_scene_to_packed.
func change_scene_to_packed(scene: PackedScene, fade_to_black: bool = false) -> void:
	# Refuse to change scene if we're already in the middle of an animation.
	if _next_scene != null:
		return
	
	_next_scene = scene
	# Stop the animation player to always reset the animation.
	$AnimationPlayer.stop()
	Dialogic.end_timeline()
	$AnimationPlayer.play("fade_in_out" if fade_to_black else "swipe")
	
