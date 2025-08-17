extends Node

const DIR := "res://items/foods"

func _ready() -> void:
	var longest_name := ""
	var dir := DirAccess.open(DIR)
	for file in dir.get_files():
		if file.ends_with(".txt"): continue
		var res = load(DIR + '/' + file)
		if res is FoodData:
			if len(res.display_name) > len(longest_name):
				longest_name = res.display_name
			
			if len(res.display_name) > 15:
				print(res.display_name)
	
	print("longest_name = ", longest_name)
