extends FoodStep

signal piping_bag_sfx
signal piping_bag_sfx_cancel

@export var max_score_window : float = 3.0 ##The percent amount +/- from 100% that the player gets full score
@export var score_loss_per_percent : float = 0.12


var piping_spots: Array[Node]
var spots_piped : int = 0 ##The running count of how many spots have been piped on
var running_score : float = 0

#@onready var piping_parent : = $PipingParent
#@onready var final_percent_text := $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piping_spots = $PipingAreas.get_children()
	for piping_spot in piping_spots:
		piping_spot.finished_piping.connect(_on_piping_spot_finished)

func _physics_process(delta: float) -> void:
	$PipingBag.position = get_global_mouse_position()

func _on_piping_spot_finished(area_percent : float) -> void:
	piping_bag_sfx_cancel.emit()
	running_score += score_piping(area_percent)
	spots_piped += 1
	print(running_score)
	if spots_piped >= piping_spots.size():
		##End Minigame
		print(running_score/spots_piped)
		finished.emit(running_score/spots_piped)
	pass


func score_piping(area_percent : float) -> float:
	##Target is 100.0(%)
	var score : float = 3.0
	
	var amount_off : float = absf(area_percent-100.0)
	if amount_off > max_score_window:
		score -= score_loss_per_percent*(amount_off-max_score_window)
	
	score = clampf(score,0,3.0)
	return score
	
	#piping_spots = piping_parent.get_children()
	#num_to_pipe = piping_spots.size()
	#print(num_to_pipe)
	#
	#for i in num_to_pipe:
		#piping_spots[i].pipping_done.connect(_pipped_spot)
#for piping_spot in $Pip
#func _pipped_spot() -> void:
	#num_to_pipe -= 1
	#if(num_to_pipe <= 0):
		#print("all Piped")
		#var added_scores: int
		#for i in piping_spots.size():
			#var temp : int = piping_spots[i]._final_score()
			#if( temp > 100):
				#temp = abs(temp-200)
			#added_scores += temp
		#var final_score :int = added_scores/piping_spots.size()
		#final_percent_text.text = str(final_score) + "%"
		#print("Final Score " + str(final_score))
		#finished.emit((final_score / 100.) * 3)
