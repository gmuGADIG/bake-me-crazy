extends Control

@export var no_date_timeline: DialogicTimeline

func _ready() -> void:
	# TODO: this should check if a date has been scheduled and
	# play different dialogic timelines accordingly.
	
	# for now, just play a temporary timeline for no dates
	Dialogic.start(no_date_timeline)
	
	await Dialogic.timeline_ended
	
	PlayerData.data.day += 1
	get_tree().change_scene_to_file("res://free_roam/world/streets/streets.tscn")
