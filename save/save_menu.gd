extends Panel


##TODO: THIS IS FOR TESTING, IT CREATES AN EMPTY RESOURCE FOR Player.data WHEN LOADED.
func _ready() -> void:
	PlayerData.data = SaveTemplate.new()



func save_file(save_slot: String) -> void:
	var result = ResourceSaver.save(PlayerData.data,"user://"+save_slot+".tres")
	if result > 0:
		push_error("Error: File did not save correctly\n"+result)
	pass



func load_file(save_slot: String) -> void:
	var path : String = "user://"+save_slot+".tres"
	if not ResourceLoader.exists(path):
		return
	var save_resource = ResourceLoader.load(path)
	PlayerData.load_file(save_resource)
	


func _on_save_1_pressed() -> void:
	save_file("save1")
	pass # Replace with function body.


func _on_save_2_pressed() -> void:
	save_file("save2")
	pass # Replace with function body.


func _on_save_3_pressed() -> void:
	save_file("save3")
	pass # Replace with function body.


func _on_load_1_pressed() -> void:
	load_file("save1")
	pass # Replace with function body.


func _on_load_2_pressed() -> void:
	load_file("save2")
	pass # Replace with function body.


func _on_load_3_pressed() -> void:
	load_file("save3")
	pass # Replace with function body.
