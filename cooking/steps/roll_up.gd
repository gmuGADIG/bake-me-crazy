extends FoodStep

@export var sprites: Array[Texture2D]
@export var expected_speed = 500
@export var speed_tolerance = 200
@export var progress_total = 10000
var cur_progress = 0
var cur_step = 0
@onready var food_sprite = $Food
var is_holding = false
var lastPos = Vector2(0,0)
var sum = 0
var num = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if len(sprites) == 0: 
		print("No sprites set in RollUp step")
		return
	food_sprite.texture = sprites[cur_step]

func progressRoll() -> void:
	if cur_step < len(sprites)-1:
		cur_step+=1
		food_sprite.texture = sprites[cur_step]
func _input(event: InputEvent) -> void:
	#if holding and speed is in range, add to progress.
	if event is InputEventMouseButton:
		process_mouse_button(event)
	if event is InputEventMouseMotion:
		process_mouse_motion(event)
	#match typeof(event):
		#InputEventMouseButton: process_mouse_button(event)
		#InputEventMouseMotion: process_mouse_motion(event)
	#next image if progress reaches total. 
func process_mouse_button(event: InputEventMouseButton):
	print(event)
	if event.is_action_pressed("interact"):
		is_holding = true
	elif event.is_action_released("interact"):
		is_holding = false
	#print(is_holding)
func process_mouse_motion(event: InputEventMouseMotion):
	#print(expected_speed)
	#if in_tolerance(-1, expected_speed, speed_tolerance):
		#print("in tolerance")
	if is_holding and in_tolerance(event.velocity.y, expected_speed, speed_tolerance):
		cur_progress += -(event.velocity.y)
		while cur_step < len(sprites) and cur_progress > progress_total / len(sprites):
			cur_progress -= progress_total / len(sprites)
			progressRoll()
		
func in_tolerance(val: float, center: float, spread: float):
	return val > (center - spread) and val < (center + spread)
	
	
