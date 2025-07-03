extends Node2D
class_name PourStepBowl

@onready var anim := %AnimationPlayer

var _p_timer := 0.0

@export var spawn_particles: bool = false

func _ready() -> void:
	anim.play("bowl_show", 0, 0.0, false)

func _physics_process(delta: float) -> void:
	var target_pos = get_global_mouse_position()
	target_pos.y *= 0.25
	target_pos.y = clamp(target_pos.y, 0, 250)
	global_position = lerp(global_position, target_pos, 0.05)
	
	if spawn_particles:
		_p_timer += 20 * delta
		while _p_timer > 0:
			var p = preload("res://cooking/steps/pour_step/pour_particle.tscn").instantiate()
			p.global_position = global_position + Vector2.from_angle(randf_range(0, TAU)) * \
				randf_range(0, 20)
			add_sibling(p)
			_p_timer -= 1
			
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("minigame_interact"):
		anim.play()
	if Input.is_action_just_released("minigame_interact"):
		anim.play_backwards()
