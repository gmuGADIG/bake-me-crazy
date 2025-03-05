class_name SaveTemplate extends Resource

## This is the script/resource that stores all data pertaining to the player, and saved progress.
## When the game is saved, all variables are stored to disk, and can be reloaded.


enum DayPhase {
  	EXPLORE,
	MORNING,
	BREAK,
	RUSH,
	CLOCKOUT,
	HOME
}

# NOTE:
# to save something between sessions, add a new variable here for it.
# It MUST be an @export variable, or it won't save.
# If anything has complicated functionality, put the logic elsewhere to keep this file organized.

#- Day Phase -#
@export_range(1,14) var day : int = 1 ## Current day, from 1 to 14
@export var day_phase : DayPhase

#- Recipes -#

#- Inventory / Items -#
@export var money : int

#- Character Data -#
@export var selected_character: int ## Currently selected character, from 0 to 5. Set from the character select screen.
