extends Node

##This is the singleton used to store the current data state in runtime. This could probably be moved to the regular Player.gd

var data := SaveTemplate.new()
var auxilary_data := AuxilarySaveData.new()

const AUXILARY_SAVE_PATH = "user://auxilary_save.tres"

## Call this when settings have been updated and need to be saved.
func save_auxilary_data():
	ResourceSaver.save(auxilary_data, AUXILARY_SAVE_PATH)

func _ready() -> void:
	Inventory.add_item(load("res://items/foods/cake_vanilla.tres"), 3)
	Inventory.add_item(load("res://items/foods/cake_vanilla.tres"), 3)
	Inventory.add_item(load("res://items/foods/cake_vanilla.tres"), 3)
	Inventory.add_item(load("res://items/foods/sweet_roll_orange.tres"), 3)
	Inventory.add_item(load("res://items/foods/sweet_roll_orange.tres"), 3)
	Inventory.add_item(load("res://items/foods/sweet_roll_orange.tres"), 3)
	Inventory.add_item(load("res://items/foods/sweet_roll_orange.tres"), 3)
	
	if ResourceLoader.exists(AUXILARY_SAVE_PATH, "AuxilarySaveData"):
		auxilary_data = ResourceLoader.load(AUXILARY_SAVE_PATH)
	if auxilary_data == null:
		auxilary_data = AuxilarySaveData.new()
	auxilary_data.restore_settings()

func load_file(save_template : SaveTemplate) -> void:
	data = save_template
	
	SceneTransition.change_scene_to_file(data.scene_path)
	if data.music_file != "":
		MainMusicPlayer.transition_to_song(load(data.music_file))
	else:
		MainMusicPlayer.stop()
	
	await get_tree().node_added # wait until scene change
	
	Dialogic.load_full_state(data.dialogic_blob)
