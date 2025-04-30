class_name NPC extends Interactable

@export var timeline: DialogicTimeline

## This variable determines which dialogic variables are read (e.g. "RP.salty", "Hearts.savory").
## Must be "salty", "sweet", "savory", or "sour", case-sensitive.
@export var character_code_name: String

var is_repeating := false

func _interact() -> void:
	## Set readonly variables
	Dialogic.VAR.read_only.possible_date = get_possible_date()
	Dialogic.VAR.read_only.repeat_talk = is_repeating
	is_repeating = true
	
	## Start timeline
	Dialogic.start(timeline)

func get_possible_date() -> int:
	if Dialogic.VAR.date != "": return 0 # date is already queued
	
	var hearts = Dialogic.VAR.hearts.get(character_code_name)
	match hearts:
		3: return 1
		6: return 2
		9: return 3
	
	return 0
