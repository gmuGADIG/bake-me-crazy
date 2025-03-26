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
	Dialogic.VAR.variable_changed.connect(heartCheck)
	#This begins the test dialogue (temporary, but for testing it's here)
	Dialogic.start('testTimeline_hearts1')

#This function checks for which variable changed (should be RP), then translates the value if enough RP can make a heart
func heartCheck(changes):
	#charName is the name of the variable that has changed
	var charName = changes["variable"]
	#newVal is the new value of the changed variable
	var newVal = changes["new_value"]
	#heartName is the name of the heart variable of the character who's RP changed
	var heartName
	#This match gets the heart name based on the character
	#If the variable that changed was not an RP value, nothing happens
	match charName:
		"saltyRP":
			heartName = "saltyHearts"
		"sourRP":
			heartName = "sourHearts"
		"savoryRP":
			heartName = "savoryHearts"
		"sweetRP":
			heartName = "sweetHearts"
		_:
			return
	
	#currHearts is the current number of hearts the character has
	var currHearts = Dialogic.VAR.get_variable(heartName)
	
	#If the new RP is below 0, it is set to 0 and the script ends
	if newVal < 0:
		Dialogic.VAR.set_variable(charName, 0)
		return
	
	#If the new value of RP exceeds the limit (specified by RP_TO_HEARTS), then the hearts get incremented and RP is set to 0
	if newVal > RP_TO_HEARTS:
		#If the character's at a date-check, then nothing happens and RP stays at max
		if currHearts % 3 == 0 and currHearts != 0:
			Dialogic.VAR.set_variable(charName, RP_TO_HEARTS)
			return
		else:
			newVal -= (RP_TO_HEARTS + 1)
			Dialogic.VAR.set_variable(heartName, (currHearts + 1))
			print("ADDED HEART!")
		Dialogic.VAR.set_variable(charName, newVal)
		
	#DEBUG STATEMENTS
	print("RP:", Dialogic.VAR.get_variable(charName))
	print("Hearts:", currHearts)
