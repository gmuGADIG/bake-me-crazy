extends CanvasLayer

func _ready() -> void:
	if not OS.has_feature("debug"): queue_free()
	visible = false

func _process(delta: float) -> void:
	var is_open = self.visible
	if not is_open and get_tree().paused: return
	
	if Input.is_action_just_pressed("debug"):
		is_open = not is_open
		get_tree().paused = is_open
		visible = is_open
