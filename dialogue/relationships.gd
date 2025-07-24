#relationships.gd
#This script translates RP to hearts when the max is reached
#The hearts cannot grow past 3, 6, 9 unless manually changed

extends Node2D
#Global var for dividing relationship points to hearts
#The variable represents how much RP becomes one heart
const RP_TO_HEARTS = 100

signal heart_gained(character_name: String)

#Function runs on load.
func _ready():
	#This makes it so anytime a variable changes, the function that turns RP to hearts is ran
	Dialogic.VAR.variable_changed.connect(_on_variable_changed)
	#This begins the test dialogue (temporary, but for testing it's here)
	#Dialogic.start('testTimeline_hearts1')
	
	heart_gained.connect(_handle_new_recipes)

func _on_variable_changed(changes: Dictionary):
	print("Variable changed!!")
	
	var var_name = changes["variable"] as String
	if var_name.begins_with("rp."):
		var character_name = var_name.trim_prefix("rp.")
		heart_check(character_name)

func heart_check(character_name):
	# get current hearts and rp
	var hearts = Dialogic.VAR.hearts.get(character_name)
	var rp = Dialogic.VAR.rp.get(character_name)
	var hearts_changed = false
		
	# convert 100 RP to +1 heart
	if rp >= RP_TO_HEARTS and not hearts in [3, 6, 9]:
		hearts += 1
		rp -= RP_TO_HEARTS
		hearts_changed = true
	
	# lock RP gain at 3, 6, and 9 hearts, until the date is completed
	if hearts in [3, 6, 9]:
		rp = 0
	
	Dialogic.VAR.hearts.set(character_name, hearts)
	Dialogic.VAR.rp.set(character_name, rp)
	
	if hearts_changed:
		heart_gained.emit(character_name)
		
	# DEBUG STATEMENTS
	print("relationships.gd: Hearts = %s, RP = %s" % [Dialogic.VAR.hearts.get(character_name), Dialogic.VAR.rp.get(character_name)])

# called when a character gains a heart. unlocks new recipes if applicable
func _handle_new_recipes(character_name) -> void:
	var hearts = Dialogic.VAR.hearts.get(character_name)
	if not hearts in [3, 6]: return # nothing new
	
	var first_recipe = (hearts == 3)
	
	var new_recipe: String
	match character_name:
		"salty": new_recipe = "res://items/recipes/macaron.tres" if first_recipe else "res://items/recipes/scone.tres"
		"savory": new_recipe = "res://items/recipes/puff_roll.tres" if first_recipe else "res://items/recipes/cannelle.tres"
		"spicy": new_recipe = "res://items/recipes/bar.tres" if first_recipe else "res://items/recipes/tart.tres"
		"sweet": new_recipe = "res://items/recipes/cookie.tres" if first_recipe else "res://items/recipes/sweet_roll.tres"
	
	print("Adding recipe: ", new_recipe)
	PlayerData.data.queued_recipe_unlocks.append(new_recipe)
