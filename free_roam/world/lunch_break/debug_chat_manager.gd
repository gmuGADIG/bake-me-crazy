extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_repeat_chat") and OS.is_debug_build():
		var npc := LunchBreakNPC.latest_npc
		if npc:
			npc.is_repeating = false
