extends FoodStep

@export var slow_threshold : float
@export var mid_threshold : float
@export var fast_threshold : float

@onready var speed_text := $Label
@onready var slider := $HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed :float = abs(Input.get_last_mouse_velocity().x)
	if speed < 10:
		speed_text.text = "NOT MOVING"
	elif speed < slow_threshold:
		speed_text.text = "SLOW"
	elif speed < mid_threshold:
		speed_text.text = "JUST RIGHT"
	elif speed < fast_threshold:
		speed_text.text = "FAST"
	slider.value = speed
	pass
