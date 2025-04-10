extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_page_down"):
		var mui = preload("res://menus/market_ui/market_ui.tscn").instantiate()
		add_child(mui)
