extends Node2D

@onready var arrow := $FullBar/Arrow
@onready var green_bar := $FullBar/GreenBar
@onready var yellowbar := $FullBar/Yellowbar
@onready var yellowbar2 := $FullBar/Yellowbar2

var mouseHold := false
@export var rollAmount := 0.0
var previous_mouse_y := 0.0

var finalScore := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#detects if mouse is being held down, and when it is released, this will determine when the minigame ends
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouseHold = true
		moveUpDown(delta)
	elif mouseHold and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):  
		mouseHold = false
		gameEnd()
		
	
func moveUpDown(delta):
	#while mousehold is true, see if you are moving it up and down
	if mouseHold:
		pass
	
	
func gameEnd():
	if finalScore == 0:
		print("YOU DID TERRIBLE! p e r i s h")
	elif finalScore == 1:
		print("YOU CAN DO BETTER")
	elif finalScore == 2:
		print("You are masterbaker")
