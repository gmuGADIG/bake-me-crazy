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
	heat_time_label.hide()
	arrow.hide()

func start():
	heat_time_label.show()
	arrow.show()

func _process(delta: float) -> void:
	heat -= delta * 0.25
	
	if Input.is_action_pressed("interact"):
		heat += delta * 2.0
		
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
