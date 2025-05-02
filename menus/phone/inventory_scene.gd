extends Control

@onready var items_container = %InventoryGrid

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

#Call when a item is selected
func set_selected(item: ItemInstance):
	%SelectedItemName.text = item.data.display_name
	%SelectedItemDescription.text = "quality: %s" % item.quality
	%SelectedItemIcon.texture = item.data.image

#Call on visibility changed
func on_app_toggle() -> void:
	if(%Inventory.visible):
		populate_item_grid()
	else:
		clear_item_grid()

#Populates ItemsContainer with items in player_inventory
func populate_item_grid() -> void:
	for item in PlayerData.data.inventory:
		var item_icon = preload("res://menus/phone/inventory_slot.tscn").instantiate()
		item_icon.icon = item.data.image
		item_icon.focus_entered.connect(set_selected.bind(item))
		items_container.add_child(item_icon)

#To be called before populate_item_grid() when UI opens
func clear_item_grid() -> void:
	for child in items_container.get_children():
		child.queue_free()
