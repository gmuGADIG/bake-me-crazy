extends FoodStep

@export var target_size: float
@export var roll_speed: float

var rolling: bool
var timer: float
var mouse_moving: bool
var mouse_vert_velocity: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rolling = false
	mouse_vert_velocity = 0


var done := false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if done: return 
	
	mouse_vert_velocity = abs(Input.get_last_mouse_velocity().y)
	
	if Input.is_action_pressed("minigame_interact") and mouse_vert_velocity > 0:
		rolling = true
	else:
		if rolling == true:
			const TARGET_SCALE := 3
			var dist := absf($dough.scale.y - TARGET_SCALE)
			if (dist < 0.5): dist = 0
			
			var score := clampf(remap(dist, 0, 3, 3, 1), 1, 3)
			
			# dont instafail if the player just clicked and didn't move
			print("roll out done; scale: ", $dough.scale.y, "; score: ", score)
			if score < 1.7 and $dough.scale.y < TARGET_SCALE: return
			
			finished.emit(clampf(score, 0, 3))
			done = true
		rolling = false
		$Sprite2D.stop()
	
	if rolling == true:
		$dough.scale.y += clamp((mouse_vert_velocity * 0.001 * delta), 0, 0.01)
		$Sprite2D.play("roll")
		$Sprite2D.speed_scale = Input.get_last_mouse_velocity().y * 0.2 * delta
