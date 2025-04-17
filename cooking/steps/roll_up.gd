extends FoodStep

@export var sprites: Array[Texture2D]
@export var expected_speed = 500
@export var speed_tolerance = 200
@export var progress_total := 10000.
var cur_progress := 0.
@onready var food_sprite = $Food
var is_holding = false

var done := false

func percent_process() -> float:
	return cur_progress / progress_total

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if len(sprites) == 0: 
		print("No sprites set in RollUp step")
		return
	food_sprite.texture = sprites[0]

func _input(event: InputEvent) -> void:
	#if holding and speed is in range, add to progress.
	if event is InputEventMouseButton:
		process_mouse_button(event)
	if event is InputEventMouseMotion:
		process_mouse_motion(event)

func process_mouse_button(event: InputEventMouseButton):
	if event.is_action_pressed("interact"):
		is_holding = true
	elif event.is_action_released("interact"):
		is_holding = false

func process_mouse_motion(event: InputEventMouseMotion):
	var vel := -event.velocity.y
	if is_holding and in_tolerance(vel, expected_speed, speed_tolerance):
		print_rich("[color=green]%s[/color]" % vel)
	elif is_holding: 
		print(vel)

	if is_holding and in_tolerance(vel, expected_speed, speed_tolerance):
		cur_progress += vel

		var desired_sprite := int(percent_process() * len(sprites))
		food_sprite.texture = sprites[min(desired_sprite, len(sprites) - 1)]
		if percent_process() >= 1. and not done:
			done = true
			finished.emit(3.)

		# while cur_step < len(sprites) and cur_progress > progress_total / float(len(sprites)):
		# 	cur_progress -= progress_total / float(len(sprites))
		# 	progressRoll()
		
func in_tolerance(val: float, center: float, spread: float):
	return val > (center - spread) and val < (center + spread)
	
	
