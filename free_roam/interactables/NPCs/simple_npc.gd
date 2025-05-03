class_name SimpleNPC extends Interactable

@export var timeline: DialogicTimeline

func _interact() -> void:
	Dialogic.start(timeline)
