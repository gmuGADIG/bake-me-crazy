extends FoodStep
class_name StepHeat

@onready var arrow := $FullBar/Arrow
@onready var heat_time_label := $HeatTimeLabel
@onready var green_bar := $FullBar/GreenBar

var heat := 0.0

var seconds_in_green := 0.0

## What portion of the heat bar is green. Between 0 and 1.
@export var green_range := 0.5

## How long the heating minigame should last.
@export var heat_time: float = 15.0

## How fast the heat variable increases when holding down the mouse.
const increase_rate := 0.25

## How fast the heat variable decreases when not holding down the mouse.
const decrease_rate := 0.5

## Track the original heat time for computing the score at the end. This should
## not be modified after _ready.
@onready var original_heat_time: float = heat_time


func _ready() -> void:
	green_range = clamp(green_range, 0.0, 1.0)
	# We set the size of the green bar based on the green range.
	green_bar.anchor_top    = 0.5 - green_range * 0.5
	green_bar.anchor_bottom = 0.5 + green_range * 0.5

## Called before we are slid into the scene.
func pre_animation():
	# set timer text and arrow position
	heat_time_label.text = "Time left: %.2f" % [original_heat_time]
	
	var anchor: float = 1.0 - ((clamp(heat, -1.0, 1.0) + 1.0) * 0.5)
	arrow.anchor_top = anchor
	arrow.anchor_bottom = anchor 

func start():
	pass

func _process(delta: float) -> void:
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		heat += delta * increase_rate
	else:
		heat -= delta * decrease_rate
		
	heat = clamp(heat, -1.0, 1.0)
	
	# If the heat is inside the green range, increase the green time.
	if heat >= -green_range and heat <= green_range:
		seconds_in_green += delta

	var anchor: float = 1.0 - ((clamp(heat, -1.0, 1.0) + 1.0) * 0.5)
	arrow.anchor_top = anchor
	arrow.anchor_bottom = anchor 
	
	# Only update the timer when it's greater than 0 so we can detect the frame
	# when it changes.
	print(heat_time)
	if heat_time > 0:
		heat_time -= delta
		heat_time_label.text = "Time left: %.2f" % [clamp(heat_time, 0.0, original_heat_time)]
		
		print(heat_time)
		# If this if passes, this is THE FRAME when the timer expired.
		if heat_time <= 0:
			print("AAAAAAAAAAAAAA")
			var ratio = clamp(seconds_in_green / original_heat_time, 0.0, 1.0)
			finished.emit(ratio * 3.0)
