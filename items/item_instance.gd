class_name ItemInstance extends Resource

## A single instance of an item. The inventory consists of several of these.
## If the player has 3 chocolate cakes, there will be a single FoodData for chocolate cake and 3 FoodInstances.

# NOTE: this file's kinda weird to work with the save system.
# it has to be a resource, even though it isn't meant to be set in the inspector.
# it has stores the path to the item data, and saves that. otherwise it would create a copy, and identity comparisons would be incorrect.
# the constructor can't take parameters, so you must create a blank ItemInstance then call `setup(...)`.

var data: ItemData:
	get():
		if data == null:
			data = load(_data_resource_path)
		return data

@export var _data_resource_path: String

@export var quality: int

func setup(item_data: ItemData, item_quality: int) -> ItemInstance:
	data = item_data
	_data_resource_path = _data_resource_path
	quality = item_quality
	
	return self
