extends CanvasLayer

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
	current_npc.talk_count += 1
	current_npc.is_repeating = true
	Dialogic.Jump.jump_to_label(str(current_npc.talk_count))
	

func compute_gift_reward(liked: bool) -> float:
	var quality = min(3, Dialogic.VAR.read_only.gift_quality)
	var reward_floor := 20 if liked else 0

	var result = reward_floor + lerp(0, 40, quality / 3.)
	print("[break_npc_system::compute_gift_reward] result = ", result)
	var gift_animation: GiftAnimation = preload("res://menus/gift_animation.tscn").instantiate()
	gift_animation.prepare(liked)
	get_tree().current_scene.add_child(gift_animation)
	return result
