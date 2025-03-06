extends Control
## Base class to control food minigame stepping logic.
class_name FoodMinigame

var steps: Array[FoodStep] = []
var step_ptr: int = 0

func next_step() -> void:
	if step_ptr < steps.size():
		# If we have a previous step, disable it.
		if step_ptr > 0:
			var prev: FoodStep = steps[step_ptr - 1]
			prev.process_mode = Node.PROCESS_MODE_DISABLED
			prev.hide() # TODO replace with polished animation.
		
		var next: FoodStep = steps[step_ptr]
		step_ptr += 1
		next.finished.connect(step_finished)
		
		# Enable the step then call its start function.
		next.process_mode = Node.PROCESS_MODE_INHERIT
		next.start()
		next.show() # TODO replace with polished animation

func step_finished(score: float) -> void:
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
			
	# Start the first step.
	next_step()
			
	
	
