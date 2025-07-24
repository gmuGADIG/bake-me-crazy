extends Area2D

signal finished_piping(percent_of_target : float)

@export var percent_gained_per_second : float = 60.0

@export var target_sprite_scale : float = 0.27 ##The scale of the piped dough when at the target amount

var in_area : bool = false
var already_piped : bool = false
var percent_piped : float = 0 ##A percentage of 100%, being the target amount piped out


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PipedDough.scale = Vector2.ZERO
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)


func _on_mouse_enter() -> void:
	in_area = true

func _on_mouse_exit() -> void:
	in_area = false


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("minigame_interact"):
		if !in_area || already_piped:
			return
		
		## Play sound
		var piping_spot_step = $"../.."
		piping_spot_step.piping_bag_sfx.emit()
		
		percent_piped += percent_gained_per_second * delta
		calculate_dough_sprite()
	
	if Input.is_action_just_released("minigame_interact") && in_area && !already_piped:
		already_piped = true
		finished_piping.emit(percent_piped)

func calculate_dough_sprite() -> void:
	var scale_val : float = clamp(target_sprite_scale*percent_piped/100.0,0,2.0*target_sprite_scale)
	$PipedDough.scale = Vector2(scale_val,scale_val)
	
	var dough_offset : Vector2 = get_global_mouse_position()-global_position
	var half_sprite_size : float = $PipedDough.scale.x*($PipedDough.texture.get_width()/2.0)
	$PipedDough.position = dough_offset.limit_length(max(dough_offset.length()-half_sprite_size,0))
	#var dist : float = global_position.distance_to(mouse_pos)
	
	
	
	
	
