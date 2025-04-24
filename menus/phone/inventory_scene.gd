extends Control

@onready var items_container = %InventoryGrid

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

#Call when a item is selected
func set_selected(item: ItemData):
	%SelectedItemName.text = item.name
	%SelectedItemDescription.text = item.description
	%SelectedItemIcon.texture = item.icon

#Call on visibility changed
func on_app_toggle() -> void:
	if(%Inventory.visible):
		populate_item_grid()
	else:
		clear_item_grid()

#Populates ItemsContainer with items in player_inventory
func populate_item_grid() -> void:
	for item in InventorySystem.player_inventory:
		var icon = TextureRect.new()
		icon.texture = item.icon
		items_container.add_child(icon)

#To be called before populate_item_grid() when UI opens
func clear_item_grid() -> void:
	for child in items_container.get_children():
		child.queue_free()
