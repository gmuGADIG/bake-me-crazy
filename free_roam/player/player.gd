extends PathFollow2D

@export var speed := 500.0

@onready var interaction_area: PlayerInteractionArea = %InteractionArea

func _process(delta: float) -> void:
	# get input
	var input := Input.get_axis("move_left", "move_right")
	# override input to zero to prevent movement while talking
	if DialogManager.is_mid_interaction(): input = 0 

	# move player along the line
	progress += input * speed * delta

func _on_interaction_area_indicator(visible: bool) -> void:
	$Dialogueindicator.visible = visible and Dialogic.current_timeline == null
