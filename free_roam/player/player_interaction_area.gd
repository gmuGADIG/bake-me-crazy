class_name PlayerInteractionArea extends Area2D

signal indicator(visible: bool)


var last_frame_mid_interaction = false
var closest_interactable : Interactable

func _input(event: InputEvent) -> void:
	await get_tree().process_frame
	if event.is_action_pressed("interact") and not last_frame_mid_interaction and not Phone.instance.phone_opened:	
		if closest_interactable != null:
			closest_interactable._interact()
			
func _process(delta: float) -> void:
	# if the interact button is pressed, call `_interact` on the nearest overlapping Interactable
	closest_interactable = _get_nearest_interactable()
	
	if closest_interactable != null:
		emit_signal("indicator", true)
	elif closest_interactable == null:
		emit_signal("indicator", false)

	last_frame_mid_interaction = DialogueManager.is_mid_interaction()
	
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
