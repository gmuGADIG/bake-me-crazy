extends Control

func _ready() -> void:
	Dialogic.timeline_started.connect(func():
		self.visible = false
	)
	
	Dialogic.timeline_ended.connect(func():
		self.visible = true
	)

func _on_salty_1_pressed() -> void:
	pass

func _on_salty_2_pressed() -> void:
	pass # Replace with function body.

func _on_salty_confession_pressed() -> void:
	pass # Replace with function body.
