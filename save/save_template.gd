class_name SaveTemplate extends Resource

##This is the script/resource that stores all data pertaining to the player, and saved progress.
##When the game is saved, all variables are stored to disk, and can be reloaded.


enum DayPhase {
  	EXPLORE,
	MORNING,
	BREAK,
	RUSH,
	CLOCKOUT,
	HOME
}

@export_range(1,14) var day : int
@export var day_phase : DayPhase
@export var money : int

##TODO: Recipes data

##TODO: Inventory/Items

##TODO: CharacterData?
	#name
	#hearts
	#DateSchedule
	#texts [
		#"afashfiasufhaieughaseig",
		#"hi",
		#"you bake be crazy"
	#]
