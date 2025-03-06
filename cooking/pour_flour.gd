extends FoodStep

var flourInBowl = 0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$FlourScale.text = str(flourInBowl)
	if(Input.is_mouse_button_pressed(1)):
		flourInBowl = flourInBowl + 1
	pass
