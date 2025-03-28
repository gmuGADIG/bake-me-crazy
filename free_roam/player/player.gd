extends PathFollow2D

@export var speed := 500.0

@onready var interaction_area: PlayerInteractionArea = %InteractionArea

func _process(delta: float) -> void:
	# get input
	var input := Input.get_axis("move_left", "move_right")
	if interaction_area.mid_interaction: input = 0 # override input to zero to prevent movement while talking

	# move player along the line
	progress += input * speed * delta
