extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func save(save_slot: String) -> void:
	var result = ResourceSaver.save(PlayerData,save_slot)
	pass
	
func load(save_slot: String) -> void:
	if not ResourceLoader.exists(save_slot):
		return
	var save_resource = ResourceLoader.load(save_slot)
	
