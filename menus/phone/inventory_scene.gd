extends Control

@onready var items_container = %InventoryGrid

#Call when a item is selected
func set_selected(item: ItemInstance):
	if item == null:
		%SelectedItemName.text = ""
		%SelectedItemDescription.text = ""
		%SelectedItemIcon.texture = null
	else:
		%SelectedItemName.text = item.data.display_name
		%SelectedItemDescription.text = "quality: %s" % item.quality
		%SelectedItemIcon.texture = item.data.image

#Call on visibility changed
func on_app_toggle() -> void:
	if %Inventory.visible:
		clear_item_grid()
		populate_item_grid()
		set_selected(null)

#Populates ItemsContainer with items in player_inventory
func populate_item_grid() -> void:
	for item in PlayerData.data.inventory:
		var item_icon = preload("res://menus/phone/inventory_slot.tscn").instantiate()
		item_icon.icon = item.data.image
		item_icon.focus_entered.connect(set_selected.bind(item))
		%InventoryGrid.add_child(item_icon)

#To be called before populate_item_grid() when UI opens
func clear_item_grid() -> void:
	for child in items_container.get_children():
		child.queue_free()
