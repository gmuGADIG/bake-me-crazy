extends CanvasLayer

func _toggle_open_close() -> void:
	var is_open = self.visible
	if not is_open and get_tree().paused: return
	
	is_open = not is_open
	get_tree().paused = is_open
	visible = is_open

func _ready() -> void:
	if not OS.has_feature("debug"): queue_free()
	visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		_toggle_open_close()


func _on_festival_button_pressed() -> void:
	get_tree().change_scene_to_file("res://dialogue/narration/festival_player.tscn")
	_toggle_open_close()


func _on_skip_day_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/day_cycle/day_cycle.tscn")
	_toggle_open_close()
