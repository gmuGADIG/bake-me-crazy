extends Node2D

@onready var arrow := $FullBar/Arrow
@onready var bar := $FullBar
@onready var rollingPin := $RollingPin

var mouseHold := false
@export var rollAmount := 0.0

var gameHasEnded := false
@export var MAX_SCORE := 800



# Called when the node enters the scene tree for the first time.
func _ready():
	rollAmount = 0.0
	pass # Replace with function body.

func update_arrow_position():
	var bar_bottom = bar.global_position.y + bar.size.y
	var bar_top = bar.global_position.y
	
	# Interpolates the arrow's Y position based on rollAmount
	var new_y = lerp(bar_bottom, bar_top, rollAmount / MAX_SCORE)
	#var new_y = bar_bottom - ((rollAmount / MAX_SCORE) * (bar_bottom - bar_top))
	#sets arrow position
	arrow.global_position.y = new_y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	#detects if mouse is being held down, and when it is released, this will determine when the minigame ends
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouseHold = true
		moveUpDown(event)
	elif mouseHold and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):  
		mouseHold = false
		gameEnd()
		
	
func moveUpDown(event):
	#while mousehold is true, see if you are moving it up and down, will only work if game is ongoing
	if event is InputEventMouseMotion and gameHasEnded == false:
		if event.relative.y == 0:
			print("Still")
		if event.relative.y > 0:
			print("Move down")
			earningPoints()
		if event.relative.y < 0:
			print("Move up")
			earningPoints()
		
		
	# function called to earn points, additionally, the rolling pin will move up and down
func earningPoints():
	
	
	if rollAmount < MAX_SCORE:
		rollAmount += 1
		rollingPin.global_position.y = get_global_mouse_position(y)
	print ("current score: ", rollAmount)
	update_arrow_position()
	
	# all the actions that occur when the game ends, checks score
func gameEnd():
	gameHasEnded = true
	
	if rollAmount >= 0 and rollAmount < 300:
		print("Score: ",rollAmount, " GRADE: C")
	elif rollAmount >= 300 and rollAmount < 400:
		print("Score: ",rollAmount, " GRADE: B!")
	elif rollAmount >= 400 and rollAmount < 500:
		print("Score: ",rollAmount, " GRADE: A!!")
	elif rollAmount >= 500:
		print("Score: ",rollAmount - 200, " GRADE: B!")
