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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_vert_velocity = abs(Input.get_last_mouse_velocity().y)
	if Input.is_action_pressed("interact") and mouse_vert_velocity > 0:
		rolling = true
	else:
		if rolling == true:
			print("roll out done")
			finished.emit()
		rolling = false
	if rolling == true :
		$dough.scale.y += clamp((mouse_vert_velocity * 0.001 * delta), 0, 0.01)
	if $dough.scale.y > target_size:
		print($dough.scale.y)
		
