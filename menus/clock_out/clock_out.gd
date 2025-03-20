extends Control

@export var no_date_timeline: DialogicTimeline
@export var datescenes: Dictionary

func _ready() -> void:
	# TODO: this should check if a date has been scheduled and
	# play different dialogic timelines accordingly.
	
	# switches to scene based on Dialogic "date" variable 
	# plays timeline for no dates if no date is found
	start_date()
	#Dialogic.start(no_date_timeline)
	await Dialogic.timeline_ended
	
	PlayerData.data.day += 1
	get_tree().change_scene_to_file("res://free_roam/world/streets/streets.tscn")

func start_date():
	if datescenes.has(Dialogic.VAR.date):
		print(datescenes[Dialogic.VAR.date])
		get_tree().change_scene_to_file(datescenes[Dialogic.VAR.date])
		Dialogic.VAR.date = ""
	else:
		if Dialogic.VAR.date != "":
			print("start_date received an invalid date variable in Dialogic!")
		Dialogic.start(no_date_timeline)
