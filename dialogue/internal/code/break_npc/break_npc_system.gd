extends CanvasLayer

## returns true if the current timeline has the label specified
func current_timeline_has_label(label: String) -> bool:
	# code copy pasted from Dialogic.Jump.jump_to_label
	var idx: int = -1
	while true:
		idx += 1
		var event: Variant = Dialogic.current_timeline.get_event(idx)
		if event == null: # we reached the end of the "event" list
			break
		if event is DialogicLabelEvent and event.name == label:
			return true
	return false

func prompt_gift():
	Dialogic.paused = true
	Dialogic.Styles.get_layout_node().hide()
	
	var prompt = preload("gift_prompt.tscn").instantiate()
	add_child(prompt)
	await prompt.tree_exiting
	
	Dialogic.paused = false
	Dialogic.Styles.get_layout_node().show()

func start_daily_chat():
	var current_npc = LunchBreakNPC.latest_npc
	
	print("[BreakNPCSystem] starting chat for ", current_npc.name)
	current_npc.talk_count += 1
	current_npc.is_repeating = true
	
	var warn_flag := false
	while not current_timeline_has_label(str(current_npc.talk_count)):
		current_npc.talk_count -= 1
		warn_flag = true
	
	if warn_flag:
		push_error("current_npc.talk_count overflowed!")
	
	print("[BreakNPCSystem] jumping to label ", current_npc.talk_count)
	Dialogic.Jump.jump_to_label(str(current_npc.talk_count))

func compute_gift_reward(liked: bool) -> float:
	var quality = min(3, Dialogic.VAR.read_only.gift_quality)
	var reward_floor := 40 if liked else 0

	var result = reward_floor + lerp(0, 80, quality / 3.)
	print("[break_npc_system::compute_gift_reward] result = ", result)
	var gift_animation: GiftAnimation = preload("res://menus/gift_animation.tscn").instantiate()
	gift_animation.prepare(liked)
	get_tree().current_scene.add_child(gift_animation)
	return result
