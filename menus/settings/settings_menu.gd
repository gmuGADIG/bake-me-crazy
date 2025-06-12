extends Control

const BOTTOM_Y = 660
var open_close_tween: Tween = null

# for animating the panel scale
var scale_theta: float = 0.0
@onready var center_panel := %CenterPanel

func animate_open_close(open: bool):
	if open_close_tween:
		open_close_tween.kill()
	open_close_tween = create_tween()
	self.position.y = BOTTOM_Y if open else 0
	open_close_tween.tween_property(self, "position:y", 0 if open else BOTTOM_Y, 0.3)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	if not open:
		open_close_tween.tween_callback(queue_free)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	animate_open_close(true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale_theta += TAU * delta * 0.7
	scale_theta = fmod(scale_theta, TAU)
	center_panel.scale.y = 1 + 0.01 * sin(scale_theta)
	center_panel.scale.x = 1 - 0.01 * cos(scale_theta)

func _on_back_button_pressed() -> void:
	animate_open_close(false)
	
