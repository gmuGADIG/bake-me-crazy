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
			print("roll out done")
			var _score = $dough.scale.y
			var dist := absf($dough.scale.y - 3)
			if (dist < 0.5): dist = 0
			var score := remap(dist, 0, 3, 3, 0)
			if score < 1.2: return
			print(score)
			finished.emit(clampf(score, 0, 3))
			done = true
		rolling = false
		$Sprite2D.stop()
	if rolling == true :
		$dough.scale.y += clamp((mouse_vert_velocity * 0.001 * delta), 0, 0.01)
		$Sprite2D.play("roll")
		$Sprite2D.speed_scale = Input.get_last_mouse_velocity().y * 0.2 * delta
