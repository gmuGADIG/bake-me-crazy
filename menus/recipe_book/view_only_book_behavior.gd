extends Node


func _ready() -> void:
	get_tree().paused = true # unpaused in _exit_tree
	MainMusicPlayer.set_volume(0.3)
	%CountertopBlue.hide()
	
	%BakeButtonz.hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") || Input.is_action_just_pressed("open_recipes"):
		%ReadOnlyOpenAnimation.play_backwards("new_animation")
		await %ReadOnlyOpenAnimation.animation_finished
		get_parent().queue_free()

func _exit_tree() -> void:
	get_tree().paused = false
	MainMusicPlayer.set_volume(1.)
