extends FoodStep

@export var slow_threshold : float
@export var mid_threshold : float
@export var fast_threshold : float

@onready var speed_text := $Label
@onready var accuracy_text := $Accuracy
@onready var slider := $HSlider

var mouse_over : bool 
var pipping: bool
var game_done: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var slowPoints:float
var rightPoints: float
var fastPoints: float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_over and Input.is_action_just_pressed("interact"):
		pipping = true
		slowPoints = 0
		rightPoints = 0
		fastPoints = 0
	if Input.is_action_just_released("interact"):
		pipping = false
		
	if pipping and !game_done:
		var speed :float = Input.get_last_mouse_velocity().y
		if speed < 10:
			speed_text.text = "NOT MOVING"
		elif speed < slow_threshold:
			speed_text.text = "SLOW"
			slowPoints += 1
		elif speed < mid_threshold:
			speed_text.text = "JUST RIGHT"
			rightPoints += 1
		elif speed < fast_threshold:
			speed_text.text = "FAST"
			fastPoints += 1
		slider.value = speed
	pass


func _on_character_body_2d_mouse_entered() -> void:
	print("Mouse over")
	mouse_over = true
	pass # Replace with function body.


func _on_character_body_2d_mouse_exited() -> void:
	mouse_over = false
	pass # Replace with function body.

func _on_end_point_mouse_entered() -> void:
	print("END")
	var totalPoints: float = slowPoints + rightPoints + fastPoints
	print("Slow: " + str(slowPoints))
	print("RIGHT: " + str(rightPoints))
	print("Fast: " + str(fastPoints))
	var right_ratio : int = (rightPoints/totalPoints) * 100
	print("RIGHT RATIO: " + str(right_ratio))
	accuracy_text.text = "Accuracy: " + str(right_ratio) + "%"
	game_done = true

	finished.emit((right_ratio / 100.) * 3)
