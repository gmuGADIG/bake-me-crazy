extends Control

# WARN: not set before (or even immediately after) _ready!
@export_enum("salty", "savory", "spicy", "sweet") var npc := "salty":
	set(v):
		npc = v
		_load_hearts()

@onready var heart_parent: HBoxContainer = %HBoxContainer

func _get_hearts_array() -> Array[float]:
	print("[heart_display] _get_hearts_array")
	var result: Array[float] = []
	result.resize(10)
	result.fill(0.)
	
	var hearts = Dialogic.VAR.hearts.get(npc)
	var rp = Dialogic.VAR.rp.get(npc)
	
	for idx in result.size():
		if hearts <= 0:
			result[idx] = rp / 100.
			rp = 0
		else:
			result[idx] = 1.
			hearts -= 1
	
	if npc == "sweet":
		pass
	
	return result

func _save_hearts() -> void:
	print("[heart_display] _save_hearts")
	PlayerData.data.hearts_ui[npc] = _get_hearts_array()

func _load_hearts() -> void:
	print("[heart_display] _load_hearts")
	if npc not in PlayerData.data.hearts_ui:
		return
	
	var fills = PlayerData.data.hearts_ui[npc]
	
	var index = 0
	for node in heart_parent.get_children():
		if node is not HeartUI: continue
		var heart := node as HeartUI
		heart.set_fill_instant(fills[index])
		index += 1

func _ready() -> void:
	#update_hearts()
	_load_hearts()
	visibility_changed.connect(func():
		if visible: update_hearts()
	)

func update_hearts() -> void:
	print("[heart_display] update_hearts")
	var hearts = Dialogic.VAR.hearts.get(npc)
	var rp = Dialogic.VAR.rp.get(npc)
	
	var index = 0
	for heart in heart_parent.get_children():
		if heart is not HeartUI: continue
		
		var fill: float
		if hearts > index: fill = 1.0
		elif hearts == index: fill = rp / 100.0
		else: fill = 0.0
		
		heart.set_fill_gradual(fill)
		#heart.set_fill_instant(fill)
		
		index += 1
	
	_save_hearts()
