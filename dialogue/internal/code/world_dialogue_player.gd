extends Node

## Dialogue will play only on this day
@export_range(1, 14) var day := 1

## This timeline will play as soon as this node is ready.
@export var timeline: DialogicTimeline

func _ready() -> void:
	if PlayerData.data.day == day:
		Dialogic.start(timeline)
	queue_free() # not needed any more
