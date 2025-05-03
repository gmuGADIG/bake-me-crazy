extends Control

func _ready() -> void:
	Dialogic.timeline_started.connect(func():
		self.visible = false
	)
	
	Dialogic.timeline_ended.connect(func():
		self.visible = true
	)

func _on_salty_1_pressed() -> void:
	Dialogic.start(load("res://dialogue/salty/callum_date_1.dtl"))

func _on_salty_2_pressed() -> void:
	Dialogic.start(load("res://dialogue/salty/callum_date_3.dtl"))

func _on_salty_confession_pressed() -> void:
	Dialogic.start(load("res://dialogue/salty/callum_date_confession.dtl"))
