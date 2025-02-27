extends Node



static var data

# Called when the node enters the scene tree for the first time.
func load_file(save_template : SaveTemplate) -> void:
	data = save_template
