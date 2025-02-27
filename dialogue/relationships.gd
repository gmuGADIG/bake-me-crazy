#relationships.gd
#This script translates RP to hearts when the max is reached
#The hearts cannot grow past 3, 6, 9 unless manually changed

extends Node2D
#Global var for dividing relationship points to hearts
#The variable represents how much RP becomes one heart
const RP_TO_HEARTS = 5

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
	#currHearts is the current number of hearts the character has
	var currHearts = Dialogic.VAR.saltyHearts
	
	if newVal > RP_TO_HEARTS:
		#If the character's at a date-check, then nothing happens and RP stays at max
		if currHearts % 3 == 0 and currHearts != 0:
			Dialogic.VAR.set_variable("saltyRP", RP_TO_HEARTS)
			return
		else:
			newVal -= (RP_TO_HEARTS + 1)
			currHearts += 1
			print("ADDED HEART!")
		Dialogic.VAR.set_variable("saltyRP", newVal)
		Dialogic.VAR.set_variable("saltyHearts", currHearts)
		
	print("RP:", Dialogic.VAR.saltyRP)
	print("Hearts:", Dialogic.VAR.saltyHearts)
