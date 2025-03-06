extends FoodStep

var flourInBowl = 0;
var overBowl = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$FlourScale.text = str(flourInBowl)
	if(Input.is_mouse_button_pressed(1) && overBowl == true):
		flourInBowl = flourInBowl + 1
	
	if(flourInBowl == 300):
		finished.emit(3)





func _on_bowl_area_body_entered(body: Node2D) -> void:
	overBowl = true;
	pass

func _on_bowl_area_body_exited(body: Node2D) -> void:
	overBowl = false;
	pass # Replace with function body.
