extends FoodStep
class_name StepHeat

@onready var arrow := $FullBar/Arrow
@onready var heat_time_label := $HeatTimeLabel

var heat := 0.0

## How long the heating minigame should last.
@export var heat_time: float = 15.0

## Called before we are slid into the scene.
func pre_animation():
	heat_time_label.hide()

func start():
	heat_time_label.show()

func _process(delta: float) -> void:
	heat -= delta * 0.25
	
	if Input.is_action_pressed("interact"):
		heat += delta * 2.0
		
	heat = clamp(heat, -1.0, 1.0)

	var anchor: float = 1.0 - ((clamp(heat, -1.0, 1.0) + 1.0) * 0.5)
	arrow.anchor_top = anchor
	arrow.anchor_bottom = anchor 
	
	# Only update the timer when it's greater than 0 so we can detect the frame
	# when it changes.
	if heat_time > 0:
		heat_time -= delta
		heat_time_label.text = "Time left: %.2f" % [clamp(heat_time, 0.0, 15.0)]
		
		# If this if passes, this is THE FRAME when the timer expired.
		if heat_time <= 0:
			# TODO track score
			finished.emit(3.0)
