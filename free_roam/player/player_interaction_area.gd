class_name PlayerInteractionArea extends Area2D

## True when the player is in the middle of talking to someone.
## This allows, for example, the player to disable movement during dialogue.
var mid_interaction: bool = false
signal indicator(visible: bool)

func _process(delta: float) -> void:
	# if the interact button is pressed, call `_interact` on the nearest overlapping Interactable
	var closest_interactable = _get_nearest_interactable()
	if Input.is_action_just_pressed("interact") and not mid_interaction:	
		if closest_interactable != null:
			closest_interactable._interact()
	elif closest_interactable != null:
		emit_signal("indicator", true)
	elif closest_interactable == null:
		emit_signal("indicator", false)

	mid_interaction = Dialogic.current_timeline != null
func _get_nearest_interactable() -> Interactable:
	var closest_interactable: Interactable = null
	var closest_distance := INF
	for body in get_overlapping_bodies():
		if body is not Interactable: continue

		var distance = self.global_position.distance_to(body.global_position)
		if distance < closest_distance:
			closest_interactable = body
			closest_distance = distance

	return closest_interactable
