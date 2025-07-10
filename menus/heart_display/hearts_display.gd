extends Control

@export_enum("salty", "savory", "spicy", "sweet") var npc := "salty"

@onready var heart_parent: HBoxContainer = %HBoxContainer

func _ready() -> void:
	#update_hearts()
	visibility_changed.connect(func():
		if visible: update_hearts()
	)

func update_hearts() -> void:
	var hearts = Dialogic.VAR.hearts.get(npc)
	var rp = Dialogic.VAR.rp.get(npc)
	
	var index = 0
	for heart in heart_parent.get_children():
		if heart is not HeartUI: continue
		
		var fill: float
		if hearts > index: fill = 1.0
		elif hearts == index: fill = rp / 100.0
		else: fill = 0.0
		
		await heart.set_fill_gradual(fill)
		#heart.set_fill_instant(fill)
		
		index += 1
