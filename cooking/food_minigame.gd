extends Control
## Base class to control food minigame stepping logic.
class_name FoodMinigame

var steps: Array[FoodStep] = []
var step_ptr: int = 0

## Timer for animating the steps in. Decreases from LENGTH to 0.
var step_slide_timer: float = 0.0

const STEP_SLIDE_DURATION: float = 1.0
const SCREEN_WIDTH := 1152.0
var current_score :float= 0

signal food_step_started
signal all_minigames_done

func next_step(score : float) -> void:
	# get the previous and next step (each may be null)
	var prev: FoodStep
	var next: FoodStep
	if step_ptr > 0 and not steps.is_empty(): prev = steps[step_ptr - 1]
	if step_ptr < steps.size(): next = steps[step_ptr]
	
	
	##Play the step completion screen
	if prev != null:
		# Animate any closing stuff here. For now, that means make the
		# recipe book leave.
		var recipe_book = prev.get_node_or_null("InstructionsPanel")
		if recipe_book != null:
			# Make sure the recipe book IS processing, cause we disable
			# the node.
			recipe_book.process_mode = Node.PROCESS_MODE_ALWAYS
			recipe_book.close_book()
		
		if MorningShift.instance:
			MorningShift.instance.current_step += 1
		
		prev.process_mode = Node.PROCESS_MODE_DISABLED
		$StepResults.display_results(score)
		await $StepResults.finised
	
	# prepare next step
	if next != null:
		next.pre_animation()
		next.visible = true
		
		# Tell the recipe book of the next step its actual number.
		var recipe_book = next.get_node_or_null("InstructionsPanel")
		if recipe_book != null:
			recipe_book.update_step_num()
	
	# animate them swiping across the screen
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_parallel()
	var animating := false
	if prev != null and next != null:
		prev.process_mode = Node.PROCESS_MODE_DISABLED
		animating = true
		print("prev animation")
		prev.position.x = 0
		tween.tween_property(prev, "position:x", -SCREEN_WIDTH, STEP_SLIDE_DURATION)
	
	if next != null:
		animating = true
		next.position.x = SCREEN_WIDTH
		tween.tween_property(next, "position:x", 0, STEP_SLIDE_DURATION)

	if animating:
		await tween.finished # wait for animation to finish
	# else:
	# 	await get_tree().create_timer(.5, false).timeout

	# disable prev (it remains visible until off-screen)
	if prev != null:
		prev.process_mode = Node.PROCESS_MODE_DISABLED
	
	# hide previous step now that it's off screen
	if prev != null:
		prev.visible = false
		
	# start next step
	if next != null:
		next.process_mode = Node.PROCESS_MODE_INHERIT
		food_step_started.emit()
		next.start()
		
		next.finished.connect(step_finished)
		
		# This is also when we finally increase the step pointer.
		step_ptr += 1
	
	# on the final step, handle the food being finished
	var food_finished = next == null
	if food_finished:
		# Show the results and then wait for the results screen to be exited.
		# At that point, this entire set of minigames is considered done, so
		# we emite the all_minigames_done signal.
		#
		# The MorningShift will wait for this signal so that it can load the
		# next part of the UI flow.
		%MorningResults.show_results(round(current_score / steps.size()))
		await %MorningResults.results_done
		
		# Wait for the morning results to hide? Then next minigame?
		all_minigames_done.emit()

func step_finished(score: float) -> void:
	print("FoodMinigame: Step finished with score ", score, " (TODO track scores visually?)")
	current_score += score
	# When we finish the last step, move on to the next one.
	
	
	
	
	next_step(score)

func _ready() -> void:
	# TODO: use inherited scenes next semester!
	if get_node_or_null("StepResults") == null:
		var step_results = preload("res://cooking/step_results.tscn")
		step_results.name = "StepResults"
		add_child(step_results)
	
	# Populate the steps with each FoodStep child.
	for child in get_children():
		if child is FoodStep:
			steps.append(child)
			
			# All steps that are not the current step are disabled.
			child.process_mode = Node.PROCESS_MODE_DISABLED
			child.hide()
			
	# For the first step, we don't animate it in. Instead, just directly
	# start it and setup the signal and such.
	if not steps.is_empty():
		steps[0].process_mode = Node.PROCESS_MODE_INHERIT
		steps[0].finished.connect(step_finished)
		steps[0].show()
		food_step_started.emit()
		steps[0].start()
		
		# Our next step will be the 2 element in the array.
		step_ptr = 1
	
func slide_finished():
	if step_ptr > 0 and not steps.is_empty():
		var prev: FoodStep = steps[step_ptr - 1]
		#prev.process_mode = Node.PROCESS_MODE_DISABLED
		# Now we actually hide the step.
		prev.hide()
		
	if step_ptr < steps.size():
		var next: FoodStep = steps[step_ptr]
		# At this point, we ACTUALLY start() the step and let it start processing.
		next.process_mode = Node.PROCESS_MODE_INHERIT
		next.start()
		
		next.finished.connect(step_finished)
		
		# This is also when we finally increase the step pointer.
		step_ptr += 1
