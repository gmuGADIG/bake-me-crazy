extends FoodStep

var num_to_pipe:int
var piping_spots: Array[Node]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piping_spots = get_children()
	num_to_pipe = piping_spots.size()
	print(num_to_pipe)
	
	for i in num_to_pipe:
		piping_spots[i].pipping_done.connect(_pipped_spot)

	pass # Replace with function body.

func _pipped_spot() -> void:
	num_to_pipe -= 1
	if(num_to_pipe <= 0):
		print("all Piped")
		var added_scores: int
		for i in piping_spots.size():
			added_scores += piping_spots[i]._final_score()
		var final_score :int = added_scores/piping_spots.size()
		print("Final Score " + str(final_score))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
