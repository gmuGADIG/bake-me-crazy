extends Control
## Base class to control food minigame stepping logic.
class_name FoodMinigame

var steps: Array[FoodStep] = []
var step_ptr: int = 0

## Timer for animating the steps in. Decreases from LENGTH to 0.
var step_slide_timer: float = 0.0

const STEP_SLIDE_LENGTH: float = 0.3

signal food_step_started

func animate_slide():
	var t := step_slide_timer / STEP_SLIDE_LENGTH
	t = 1.0 - t
	
	if step_ptr > 0 and not steps.is_empty():
		var prev: FoodStep = steps[step_ptr - 1]
		prev.anchor_left  = lerp(0.0, -1.0, t)
		prev.anchor_right = lerp(1.0,  0.0, t)
		
	if step_ptr < steps.size():
		var cur: FoodStep = steps[step_ptr]
		cur.anchor_left  = lerp(1.0, 0.0, t)
		cur.anchor_right = lerp(2.0, 1.0, t)

func next_step() -> void:
	# If we have a previous step, disable it.
	if step_ptr > 0:
		var prev: FoodStep = steps[step_ptr - 1]
		prev.process_mode = Node.PROCESS_MODE_DISABLED
		#prev.hide() # TODO replace with polished animation.
	
	if step_ptr < steps.size():
		var next: FoodStep = steps[step_ptr]
		# Pre animation step.
		next.pre_animation()
		# All we do before the step is slid in is show it.
		next.show()
		
	# Start the slide animation. We do this even for the last step so that
	# it goes away. TODO Add like a final screen or whatever
	step_slide_timer = STEP_SLIDE_LENGTH
	
	# We must animate_slide() to start to put everything off screen.
	animate_slide()

func step_finished(score: float) -> void:
	print("FoodMinigame: Step finished with score ", score, " (TODO track scores visually?)")
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
		food_step_started.emit()
		next.start()
		
		next.finished.connect(step_finished)
		
		# This is also when we finally increase the step pointer.
		step_ptr += 1
	
func _process(delta: float) -> void:
	if step_slide_timer > 0.0:
		step_slide_timer -= delta
		animate_slide()
		
		# Once the timer expires, we start the next step and hide the previous
		# one for real. (or queue_free it).
		if step_slide_timer <= 0.0:
			slide_finished()
			
	
	
