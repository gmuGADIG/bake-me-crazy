extends Button
var time_passed := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	var offset = 1 * 0.5  # Slight phase shift for each button
	rotation_degrees = sin(time_passed * 5 + offset) * 5  # Wiggle effect
	pass
