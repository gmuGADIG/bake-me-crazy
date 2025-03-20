extends Control

@onready var items_container = $MarginContainer/Hbox/ItemsContainer
@onready var item_info_container = $MarginContainer/ItemInfo

### Change if moved 
const item_slot = preload("res://test_scenes/item_info.tscn")


func _ready() -> void:
	populate_item_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Populates ItemsContainer with items in player_inventory
func populate_item_grid() -> void:
	for item in PlayerInventory.player_inventory:
		var slot = item_slot.instantiate()
		slot.set_item_slot_data(item)
		items_container.add_child(slot)

#To be called before populate_item_grid() when UI opens
func clear_item_grid() -> void:
	for child in items_container:
		child.queue_free()
