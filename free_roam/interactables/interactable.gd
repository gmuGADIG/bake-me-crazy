class_name Interactable extends StaticBody2D

func _ready() -> void:
	const NPC_LAYER = 1 << 2
	assert(collision_layer & NPC_LAYER, "Interactable is on the wrong layer! Make sure the collision layer has the NPC layer.")

## Abstract function called upon interacting. Subclasses should override this.
func _interact() -> void:
	pass
