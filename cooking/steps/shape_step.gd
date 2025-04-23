extends FoodStep
class_name ShapeStep
## Represents a [code]FoodStep[/code] in which you shape a piece of dough.
##
## This script detects applicable player motion and assess a score based on performance.

enum {PENDING, IN_PROGRESS, FINISHED}
enum {BEFORE, START_FRAME, MIDDLE, END_FRAME, AFTER}

@export_group("Positioning")
## The [Vector2] point that will be used as the central point.
@export var origin : Vector2 #(576, 324)
## The maximum distance from the center from which inputs will be allowed.
@export var radius : float # greater than 0, 300 right now

# TODO: consider having a "min_radius" and a "max_radius"

@export_group("Scoring") # TODO: ponder whether these should be included
@export var red_zone_width : int = 20
@export var yellow_zone_width : int = 20
@export var green_zone_width : int = 20

var progress := PENDING
var previous_progress := PENDING

var stage := BEFORE

var mouse_position : Vector2
var previous_mouse_position : Vector2

func _ready() -> void:
	radius = 300 if radius == 0 else abs(radius)
	print(radius)
	pass

func pre_animation():
	pass
	
func start():
	pass

func _process(delta: float) -> void:
	set_stage()
	previous_progress = progress
	
	if (stage == BEFORE):
		if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			progress = IN_PROGRESS
	elif (stage == START_FRAME):
		# TODO: take first angle data and put into previous angle data
		# TODO: have some sort of net_angle and prev_net_angle to keep track of signs
		pass
	elif (stage == MIDDLE):
		if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			# TODO: calculate net angle and see if its not zero 
			# or a different sign than the previous frame's net angle
			
			# this is a lot of variables i just realized lol
			pass
		else:
			progress = FINISHED
	
	pass

func set_stage() -> void:
	if (progress == PENDING):
		#print("Pending input")
		stage = BEFORE
	elif (progress == IN_PROGRESS and previous_progress == PENDING):
		#print("Minigame started!")
		stage = START_FRAME
	elif (progress == IN_PROGRESS and previous_progress == IN_PROGRESS):
		#print("Minigame is continuing!")
		stage = MIDDLE
	elif (progress == FINISHED and previous_progress == IN_PROGRESS):
		#print("Minigame just finished!")
		stage = END_FRAME
	else:
		#print("Minigame is not accepting inputs at this time!")
		stage = AFTER
