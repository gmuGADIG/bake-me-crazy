extends Control

@onready var gameTimer: Label = $gameTimer
@onready var bowl: Area2D = $Bowl

#Time limit
var timeLimit = 15
#Booleans to help w/ scooping
var isScooped = false
var mouseAtBowl = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Started!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Timer Code
	if timeLimit > 0:
		if timeLimit - delta != 0:
			timeLimit -= delta
		else:
			timeLimit = 0.001
		gameTimer.text = "Time left: %.2f" % timeLimit


	#Bowl Code
	#This code should detect when the bowl is clicked,
	#and scoops a new scoop of cookie dough
func _input(event: InputEvent) -> void:
	#print("Input: ", event.is_action_pressed)
	if event.is_action("interact") && mouseAtBowl == true && isScooped == false:
		isScooped = true;
		print("Scooped!")


#Signals to detect whether the mouse's position is at the bowl or not
#Used to help determine if cookie dough can be scooped
func _on_bowl_mouse_entered() -> void:
	print("Entered")
	mouseAtBowl = true

func _on_bowl_mouse_exited() -> void:
	print("Exited")
	mouseAtBowl = false
	
