extends Control

@export var no_date_timeline: DialogicTimeline
@export var datescenes: Dictionary

func _ready() -> void:
	# TODO: this should check if a date has been scheduled and
	# play different dialogic timelines accordingly.
	
	# normally, Dialogic.current_timeline would be null
	# it may not be null if we're loading from a save, in that case, we dont 
	# want to disrupt the loaded VN sequence
	if Dialogic.current_timeline == null:
		# switches to scene based on Dialogic "date" variable 
		# plays timeline for no dates if no date is found
		MainMusicPlayer.soft_stop()
		start_date()
	
	await Dialogic.timeline_ended
	
	assert(not DialogueManager.mid_date, "A date wasn't properly ended! It's probably missing a call to end_date_pass or end_date_fail?")
	
	PlayerData.data.day += 1
	SceneTransition.change_scene_to_packed(preload("res://menus/day_cycle/day_cycle.tscn"))

func start_date():
	# initialize some variables
	Dialogic.VAR.date_failed = false
	Dialogic.VAR.dateRP = 0
	
	# start the date
	if datescenes.has(Dialogic.VAR.date):
		print(datescenes[Dialogic.VAR.date])
		Dialogic.start(datescenes[Dialogic.VAR.date])
		Dialogic.VAR.date = ""
		DialogueManager.mid_date = true
	else:
		if Dialogic.VAR.date != "":
			print("Invalid date! Dialogic.VAR.date = '%s'. This must have a matching entry in clock_out.tscn's dictionary." % Dialogic.VAR.date)
		Dialogic.start(no_date_timeline)
