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

func get_day_phase_string() -> StringName:
	match day_phase:
		DayPhase.EXPLORE:  return "Exploring"
		DayPhase.MORNING:  return "Morning"
		DayPhase.BREAK:    return "Break"
		DayPhase.RUSH:     return "Lunch Rush"
		DayPhase.CLOCKOUT: return "Clock Out"
		DayPhase.HOME:     return "At Home"
		_: return "Unknown"

#- Recipes -#
@export var unlocked_recipe_paths: Array[String] = [
	"res://items/recipes/cake.tres",
	"res://items/recipes/croissant.tres",
	"res://items/recipes/bread.tres",
	"res://items/recipes/brownie.tres"
]
@export var queued_recipe_unlocks: Array[String]

#- Inventory / Items -#
@export var money : int = 250
@export var inventory: Array[ItemInstance]

#- Character Data -#
@export var selected_character: int ## Currently selected character, from 0 to 5. Set from the character select screen.

@export_storage var scene_path := ""
@export_storage var dialogic_blob := {}
