extends FoodStep

var num_to_pipe:int
var piping_spots: Array[Node]
@onready var piping_parent:= $PipingParent
@onready var final_percent_text := $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piping_spots = piping_parent.get_children()
	num_to_pipe = piping_spots.size()
	print(num_to_pipe)
	
	for i in num_to_pipe:
		piping_spots[i].pipping_done.connect(_pipped_spot)

func _pipped_spot() -> void:
	num_to_pipe -= 1
	if(num_to_pipe <= 0):
		print("all Piped")
		var added_scores: int
		for i in piping_spots.size():
			var temp : int = piping_spots[i]._final_score()
			if( temp > 100):
				temp = abs(temp-200)
			added_scores += temp
		var final_score :int = added_scores/piping_spots.size()
		final_percent_text.text = str(final_score) + "%"
		print("Final Score " + str(final_score))
		finished.emit((final_score / 100.) * 3)
