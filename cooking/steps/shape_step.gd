extends FoodStep
class_name ShapeStep
## Represents a [code]FoodStep[/code] in which you shape a piece of dough.
##
## This script detects applicable player motion and assesses a score based on performance.

enum {PENDING, IN_PROGRESS, FINISHED} # minigame tracking
enum {BEFORE, START_FRAME, MIDDLE, END_FRAME, AFTER} # what stage the actual shaping is in

@export_group("Positioning")
## The [Vector2] point that will be used as the central point.
@export var origin : Vector2 = Vector2(576, 324)
## The minimum and maximum radius bounds for mouse input
@export var min_radius : float = 50.0
@export var max_radius : float = 300.0

@export_group("Scoring")
@export var red_yellow_threshold : float = 20
@export var yellow_green_threshold : float = 40
@export var green_yellow_threshold : float = 60
@export var yellow_red_threshold : float = 80

@onready var progress_pointer : Sprite2D = %GoodnessPointer

var progress_top_px : int = 20
var progress_bottom_px : int = 590
var progress_height = 50

var progress := PENDING
var previous_progress := PENDING
var stage := BEFORE

var previous_angle := 0.0
var net_rotation := 0.0
var previous_net_rotation := 0.0
var initial_direction := 0 # to account for people starting CCW vs CW

func _ready() -> void:
	min_radius = max(min_radius, 0.0)
	max_radius = max(max_radius, min_radius + 1.0)
	
	progress_pointer.position.y = progress_bottom_px

func pre_animation():
	pass

func start():
	progress = PENDING
	net_rotation = 0.0
	initial_direction = 0

func _process(delta: float) -> void:
	set_stage()
	previous_progress = progress
	
	if stage == BEFORE:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if is_mouse_within_bounds():
				progress = IN_PROGRESS

	elif stage == START_FRAME:
		previous_angle = get_mouse_angle()
		net_rotation = 0.0
		initial_direction = 0 # set after first real movement

	# this is where you wanna implement the dough art changing logic later
	elif stage == MIDDLE:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if is_mouse_within_bounds():
				var current_angle = get_mouse_angle()
				var angle_diff = wrapf(current_angle - previous_angle, -PI, PI) # smaller angle diff

				if abs(angle_diff) < 0.01:
					# ignore jitter
					return

				var current_direction = sign(angle_diff) # we now have the direction!
				
				#if initial_direction == 0:
					#initial_direction = current_direction
				#elif current_direction != initial_direction:
					## you must keep going in the same direction (CW/CCW) you started, or else
					## the minigame instantly ends (if you change direction)
					#progress = FINISHED
					#return

				net_rotation += absf(angle_diff)
				$Dough.rotation += angle_diff
				previous_angle = current_angle
			else:
				print("asdfgasdfghadsfgsdf")
				# outside valid region
				progress = FINISHED
		else:
			# mouse released
			progress = FINISHED
		
		var current_score = get_current_score()
		progress_pointer.position.y = progress_bottom_px - ((current_score / 10) * progress_height)

	elif stage == END_FRAME:
		if get_current_score() < 5: 
			progress = PENDING
			return
		var score = assess_score()
		emit_signal("finished", score)	
		progress = FINISHED

func set_stage() -> void:
	if progress == PENDING:
		stage = BEFORE
	elif progress == IN_PROGRESS and previous_progress == PENDING:
		stage = START_FRAME
	elif progress == IN_PROGRESS and previous_progress == IN_PROGRESS:
		stage = MIDDLE
	elif progress == FINISHED and previous_progress == IN_PROGRESS:
		stage = END_FRAME
	else:
		stage = AFTER

func get_mouse_angle() -> float:
	return (get_global_mouse_position() - origin).angle()

func is_mouse_within_bounds() -> bool:
	var dist = (get_global_mouse_position() - origin).length()
	print(dist)
	return dist >= min_radius and dist <= max_radius

func assess_score() -> float:
	
	var score = get_current_score()
	
	var final_score = 0
	
	if (score < red_yellow_threshold or score > yellow_red_threshold):
		final_score = 1
	elif (score < yellow_green_threshold or score > green_yellow_threshold):
		final_score = 2
	else:
		final_score = 3
		
	print("Raw Score: ", score, " Final Score: ", final_score, "\n\n")
	
	return final_score
	
func get_current_score() -> float:
	var revolutions = abs(net_rotation) / (2 * PI)
	# for every full turn, add 10 to the score up to 100
	return clamp(revolutions * 10, 0.0, 100.0)
