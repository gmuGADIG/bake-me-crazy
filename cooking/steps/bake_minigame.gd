extends Node2D


var game_started : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if !game_started:
		if(event.is_action_pressed("interact")):
			$CanvasLayer/ColorRect.visible = false
			$CanvasLayer/Label.visible = false
			$CanvasLayer/StepHeat.process_mode = Node.PROCESS_MODE_INHERIT
			game_started = true
		
		
		
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
