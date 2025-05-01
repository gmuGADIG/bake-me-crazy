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


signal all_minigames_done()

func next_step() -> void:
	# get the previous and next step (each may be null)
	var prev: FoodStep
	var next: FoodStep
	if step_ptr > 0 and not steps.is_empty(): prev = steps[step_ptr - 1]
	if step_ptr < steps.size(): next = steps[step_ptr]
	
	# disable prev (it remains visible until off-screen)
	if prev != null:
		prev.process_mode = Node.PROCESS_MODE_DISABLED
	
	# prepare next step
	if next != null:
		next.pre_animation()
		next.visible = true
	
	# animate them swiping across the screen
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_parallel()
	if prev != null:
		prev.position.x = 0
		tween.tween_property(prev, "position:x", -SCREEN_WIDTH, STEP_SLIDE_DURATION)
	
	if next != null:
		next.position.x = SCREEN_WIDTH
		tween.tween_property(next, "position:x", 0, STEP_SLIDE_DURATION)

	await tween.finished # wait for animation to finish
	
	# hide previous step now that it's off screen
	if prev != null:
		prev.visible = false
		
	# start next step
	if next != null:
		next.process_mode = Node.PROCESS_MODE_INHERIT
		next.start()
		
		next.finished.connect(step_finished)
		
		# This is also when we finally increase the step pointer.
		step_ptr += 1
	
	# on the final step, handle the food being finished
	var food_finished = next == null
	if food_finished:
		# TODO: handle this properly. there should be a final screen displaying your food.
		# there should probably be a food_finished signal, which is handled by something else
		# to either prepare the next food, or load the next scene.
		# for now, just change to the lunch break
		

		%MorningResults.show_results(round(current_score / steps.size()))
		await %MorningResults.results_done
		
		# Wait for the morning results to hide? Then next minigame?
		
		all_minigames_done.emit()
		#SceneTransition.change_scene_to_file("res://free_roam/world/lunch_break/lunch_break.tscn")

func step_finished(score: float) -> void:
	print("FoodMinigame: Step finished with score ", score, " (TODO track scores visually?)")
	current_score += score
	# When we finish the last step, move on to the next one.
	next_step()

func _ready() -> void:
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
