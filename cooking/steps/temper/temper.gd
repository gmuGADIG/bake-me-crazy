extends StepHeat

@export var temper_particle : PackedScene

@export var stir_sensitivity : float = 0.00007
@export var cooldown_acceleration : float = 0.05
@export var heat_velocity_max : float = 0.02
@export var heat_velocity_min : float = -0.02

static var ladle_limits : Array[int] = [386,818]

var last_x_pos : float
var heat_velocity : float = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("minigame_interact"):
		last_x_pos = clamp(get_global_mouse_position().x,ladle_limits[0],ladle_limits[1])

func _physics_process(delta: float) -> void:
	var new_x_pos : float = clamp(get_global_mouse_position().x,ladle_limits[0],ladle_limits[1])
	$Ladle.position.x = new_x_pos
	var x_dist : float = abs(last_x_pos-new_x_pos)
	
	heat_velocity = clamp(heat_velocity - cooldown_acceleration * delta,heat_velocity_min,heat_velocity_max)
	
	if Input.is_action_pressed("minigame_interact"):
		heat_velocity += x_dist * stir_sensitivity
	
	$EggStream._update_egg_stream(delta,$Ladle.position,x_dist)
	last_x_pos = new_x_pos


func _process(delta: float) -> void:
	##Normal Step Heat Logic
	heat += heat_velocity
	if heat < -1 || heat > 1:
		heat_velocity = 0
		heat = clamp(heat, -1.0, 1.0)
	
	# If the heat is inside the green range, increase the green time.
	if heat >= -green_range and heat <= green_range:
		seconds_in_green += delta

	var anchor: float = 1.0 - ((clamp(heat, -1.0, 1.0) + 1.0) * 0.5)
	arrow.anchor_top = anchor
	arrow.anchor_bottom = anchor 
	
	# Only update the timer when it's greater than 0 so we can detect the frame
	# when it changes.
	if heat_time > 0:
		heat_time -= delta
		heat_time_label.text = "Time left: %.2f" % [clamp(heat_time, 0.0, original_heat_time)]
		
		# If this if passes, this is THE FRAME when the timer expired.
		if heat_time <= 0:
			var ratio = clamp(seconds_in_green / original_heat_time, 0.0, 1.0)
			finished.emit(ratio * 3.0)
