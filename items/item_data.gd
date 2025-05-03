class_name ItemData extends Resource

## Abstract Class; see FoodData and IngredientData
## The data for all items is stored as resources in the file system.

@export var display_name: String

@export var image: Texture2D

func _init() -> void:
	if OS.has_feature("debug"):
		await (Engine.get_main_loop() as SceneTree).process_frame
		var is_saved_to_file = not resource_path.contains("::")
		assert(is_saved_to_file, "Error: All ItemData's should be saved to a file!")
