extends Interactable

@export_multiline var interact_message: String ## What to print when interacted with

func _interact() -> void:
	print(interact_message)
