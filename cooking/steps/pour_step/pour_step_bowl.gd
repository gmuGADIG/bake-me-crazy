extends Node2D
class_name PourStepBowl

@onready var anim := %AnimationPlayer

func _ready() -> void:
	anim.play("bowl_show", 0, 0.0, true)

func _physics_process(delta: float) -> void:
	var target_pos = get_global_mouse_position()
	global_position = lerp(global_position, target_pos, 0.05)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("minigame_interact"):
		anim.play_backwards()
	if Input.is_action_just_released("minigame_interact"):
		anim.play()
