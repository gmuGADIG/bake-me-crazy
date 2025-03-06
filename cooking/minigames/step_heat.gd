extends FoodStep
class_name StepHeat

@onready var arrow := $UILayer/FullBar/Arrow

var heat := 0.0

func step_hide():
	$UILayer.hide()
	
func step_show():
	$UILayer.show()

func start():
	pass

func _process(delta: float) -> void:
	heat -= delta * 0.25
	
	if Input.is_action_pressed("interact"):
		heat += delta * 2.0
		
	heat = clamp(heat, -1.0, 1.0)

	var anchor: float = 1.0 - ((clamp(heat, -1.0, 1.0) + 1.0) * 0.5)
	arrow.anchor_top = anchor
	arrow.anchor_bottom = anchor 
