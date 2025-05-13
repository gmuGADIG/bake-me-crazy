class_name LunchBreakNPC extends Interactable

## When any lunch break npc is talked to, this is set to them.
## Allows dialogic functions to reference which NPC is being talked to.
static var latest_npc: LunchBreakNPC

## Dictionary[npc_code_name: String] -> days interacted (int)
static var _talk_count_dict: Dictionary

## This variable determines which dialogic variables are read (e.g. "RP.salty", "Hearts.savory").
## Must be "salty", "sweet", "savory", or "sour", case-sensitive.
@export var character_code_name: String

@export var main_timeline: DialogicTimeline

var is_repeating := false # set by break_npc_system when a daily chat is started

var talk_count: int:
	set(value):
		_talk_count_dict[character_code_name] = value
	get():
		if _talk_count_dict.has(character_code_name):
			return _talk_count_dict[character_code_name]
		else:
			return 0

func _interact() -> void:
	latest_npc = self
	
	## Set readonly variables
	Dialogic.VAR.read_only.possible_date = get_possible_date()
	Dialogic.VAR.read_only.repeat_talk = is_repeating
	
	## Start timeline
	Dialogic.start(main_timeline)

func get_possible_date() -> int:
	if Dialogic.VAR.date != "": return 0 # date is already queued
	
	var hearts = Dialogic.VAR.hearts.get(character_code_name)
	match hearts:
		3: return 1
		6: return 2
		9: return 3
	
	return 0
