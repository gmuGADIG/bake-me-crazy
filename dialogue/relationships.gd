"""
relationships.gd
This script is a relationship manager for all of the relationships.
Relationship information (RP and hearts) are stored in dictionaries.
This script includes the functions:
	- getRP
	- getHearts
	- addRP
	- removeRP

Written by Cian Barrett
"""
extends Node2D
#Global var for dividing relationship points to hearts
#The variable represents how much RP becomes one heart
const RP_TO_HEARTS = 5  #5 is a placeholder for now.

#These variables are integers that represent the RP w/ the various NPCs
var saltyRP = 0
var savoryRP = 0
var sourRP = 0
var sweetRP = 0

#This is a dictionary that holds the amount of RP per character
var rpDict = {
	"salty" : saltyRP,
	"savory" : savoryRP,
	"sour" : sourRP,
	"sweet" : sweetRP
}

#These variables are integers that represent the relationship level w/ the various NPCs
var saltyHearts = 0
var savoryHearts = 0
var sourHearts = 0
var sweetHearts = 0 #haha

#This is a dictionary that holds the relationship character w/ each character
var heartsDict = {
	"salty" : saltyHearts,
	"savory" : savoryHearts,
	"sour" : sourHearts,
	"sweet" : sweetHearts
}

#Function runs on load.
func _ready():
	#This makes it so any signals sent via Dialogic would have the argument of that signal run through signalDecode
	Dialogic.signal_event.connect(signalDecode)
	#This begins the test dialogue (temporary, but for testing it's here)
	Dialogic.start('testTimeline_hearts1')

"""
signalDecode
This is a function that decodes an argument sent by a Dialogic signal
Dialogic signals can only send one argument, as either a String or an int
This function takes that single string argument and turns it into something that can be put into our addRP and removeRP functions.

IMPORTANT: FOR THIS FUNCTION TO WORK, DIALOGIC ARGUMENTS HAVE TO BE FORMATTED AS:
	"[add/rm]_[character]_[amount of RP]"
		-[add/rm] : tells whether we are adding or removing RP.
		-[character] : tells which character's RP is being manipulated.
		-[amount of RP] : the amount of RP to add.
"""
func signalDecode(arg: String):
	#Parse the argument into multiple paramenters
	var parsedArgs = arg.split("_")
	
	#Calls the addRP or removeRP function based on arguments
	if(parsedArgs[0] == "add"):
		addRP(parsedArgs[1], int(parsedArgs[2]))
	elif (parsedArgs[0] == "rm"):
		removeRP(parsedArgs[1], int(parsedArgs[2]))

"""
getRP
This is a function that returns the amount of RP a character has
"""
func getRP(character: String):
	#Lowercase the character to decrease the amount of errors
	character = character.to_lower()
	
	#If the character does not exist, null is returned
	if character not in rpDict:
		print("Error in getRP: Character does not exist!")
		return null
	#End of function
	return rpDict[character]

"""
getHearts
This is a function that returns the amount of RP a character has
"""
func getHearts(character: String):
	#Lowercase the character to decrease the amount of errors
	character = character.to_lower()
	
	#If the character does not exist, null is returned
	if character not in heartsDict:
		print("Error in getHearts: Character does not exist!")
		return null
	#End of function
	return heartsDict[character]

"""
addRP
This is a function that takes in a character's name and an amount of RP to add to their current RP
Returns -1 on failure, 0 on success
"""
func addRP(character: String, amount: int):
	#Lowercase the character to decrease the amount of errors
	character = character.to_lower()
	
	#Check to see if the character is an existing character
	#If not, return -1
	if character not in rpDict:
		print("Error in relationships.gd: Character for addRP does not exist!")
		return -1
	
	"""DEBUG STATEMENTS"""
	print(character, "'s Current RP (before add): ", rpDict[character])
	print(character, "'s Current Hearts (before add): ", heartsDict[character])
	
	#If the character exists, add the RP to the character's current RP
	rpDict[character] += amount
	#If the amount of RP is enough to add another heart, the RP is subtracted by the amount from the character and a heart is added
	if (rpDict[character] / RP_TO_HEARTS >= 1):
		rpDict[character] -= RP_TO_HEARTS
		#If the character has less than the max amount of hearts, a heart is added
		if heartsDict[character] < 10:
			heartsDict[character] += 1
	
	"""DEBUG STATEMENTS"""
	print(character, "'s New RP (after add): ", rpDict[character])
	print(character, "'s Current Hearts (after add): ", heartsDict[character])
	
	#End of function
	return 0

"""
remoevRP
This is a function that takes in a character's name and an amount of RP to remove from their current RP
Returns -1 on failure, 0 on success
"""
func removeRP(character: String, amount: int):
	#Lowercase the character to decrease the amount of errors
	character = character.to_lower()
	
	#Check to see if the character is an existing character
	#If not, return -1
	if character not in rpDict:
		print("Error in relationships.gd: Character for removeRP does not exist!")
		return -1
	
	"""DEBUG STATEMENTS"""
	print(character, "'s Current RP (before remove): ", rpDict[character])
	print(character, "'s Current Hearts (before remove): ", heartsDict[character])
	
	#If the character exists, and has RP already, remove the RP to the character's current RP
	if (rpDict[character] > 0):
		rpDict[character] -= amount
	
	#If the amount of RP is negative, a heart is taken away and the amount of RP of the character becomes positive
	if (rpDict[character] <= 0) and (heartsDict[character] > 0):
		rpDict[character] += (RP_TO_HEARTS - 1)
		#If the character has more than zero hearts, a heart is removed
		heartsDict[character] -= 1
	
	"""DEBUG STATEMENTS"""
	print(character, "'s New RP (after remove): ", rpDict[character])
	print(character, "'s Current Hearts (after remove): ", heartsDict[character])
	
	#End of function
	return 0
