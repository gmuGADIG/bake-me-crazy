#relationships.gd
#This script translates RP to hearts when the max is reached
#The hearts cannot grow past 3, 6, 9 unless manually changed

extends Node2D
#Global var for dividing relationship points to hearts
#The variable represents how much RP becomes one heart
const RP_TO_HEARTS = 100

#Function runs on load.
func _ready():
	#This makes it so anytime a variable changes, the function that turns RP to hearts is ran
	Dialogic.VAR.variable_changed.connect(_on_variable_changed)
	#This begins the test dialogue (temporary, but for testing it's here)
	#Dialogic.start('testTimeline_hearts1')

func _on_variable_changed(changes: Dictionary):
	var var_name = changes["variable"] as String
	if var_name.begins_with("rp."):
		var character_name = var_name.trim_prefix("rp.")
		heart_check(character_name)

func heart_check(character_name):
	# get current hearts and rp
	var hearts = Dialogic.VAR.hearts.get(character_name)
	var rp = Dialogic.VAR.rp.get(character_name)
		
	# convert 100 RP to +1 heart
	if rp >= RP_TO_HEARTS and not hearts in [3, 6, 9]:
		hearts += 1
		rp -= RP_TO_HEARTS
	
	# lock RP gain at 3, 6, and 9 hearts, until the date is completed
	if hearts in [3, 6, 9]:
		rp = 0
	
	Dialogic.VAR.hearts.set(character_name, hearts)
	Dialogic.VAR.rp.set(character_name, rp)
	
	# DEBUG STATEMENTS
	print("relationships.gd: Hearts = %s, RP = %s" % [Dialogic.VAR.hearts.get(character_name), Dialogic.VAR.rp.get(character_name)])
