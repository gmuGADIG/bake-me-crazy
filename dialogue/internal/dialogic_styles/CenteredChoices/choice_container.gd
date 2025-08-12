extends VBoxContainer

const MAX_SPAN := 650.0

func _limit_span():
	if size.x > MAX_SPAN:
		var half_margin = (size.x - MAX_SPAN) / 2
		
		add_theme_constant_override("margin_left", half_margin)
		add_theme_constant_override("margin_right", half_margin)
	else:
		add_theme_constant_override("margin_left", 5)
		add_theme_constant_override("margin_right", 5)


func _on_choices_resized() -> void:
	_limit_span()
