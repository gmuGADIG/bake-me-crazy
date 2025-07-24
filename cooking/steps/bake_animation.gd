extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		play("Moving")
	else:
		play("Idle")
