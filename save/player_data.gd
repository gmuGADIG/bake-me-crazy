extends Node

##This is the singleton used to store the current data state in runtime. This could probably be moved to the regular Player.gd


static var data


func load_file(save_template : SaveTemplate) -> void:
	data = save_template
