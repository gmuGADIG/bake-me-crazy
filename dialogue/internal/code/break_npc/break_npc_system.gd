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
	Dialogic.Jump.jump_to_label("day%s" % current_npc.talk_count)
	
	current_npc.talk_count += 1
	current_npc.is_repeating = true
