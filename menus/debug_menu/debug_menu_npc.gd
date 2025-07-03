extends HBoxContainer

@export var npc_name: String

@onready var name_label: Label = %Name
@onready var stats_label: Label = %Stats

func _process(delta: float) -> void:
	var hearts = Dialogic.VAR.hearts.get(npc_name)
	var rp = Dialogic.VAR.rp.get(npc_name)
	
	name_label.text = npc_name
	stats_label.text = "%d♥ (%d/100 RP)" % [hearts, rp]

func _on_add_rp_50_pressed() -> void:
	var rp = Dialogic.VAR.rp.get(npc_name)
	rp += 50
	Dialogic.VAR.rp.set(npc_name, rp)
	Dialogic.VAR.variable_changed.emit({
		"variable" : "rp.%s" % npc_name,
		"new_value" : rp
	})

func _on_add_rp_5_pressed() -> void:
	var rp = Dialogic.VAR.rp.get(npc_name)
	rp += 5
	Dialogic.VAR.rp.set(npc_name, rp)
	Dialogic.VAR.variable_changed.emit({
		"variable" : "rp.%s" % npc_name,
		"new_value" : rp
	})
