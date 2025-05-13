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
		#var item_icon = preload("res://menus/phone/inventory_slot.tscn").instantiate()
		var item_icon = TextureButton.new()
		item_icon.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		item_icon.ignore_texture_size = true
		item_icon.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		item_icon.size_flags_vertical = Control.SIZE_EXPAND_FILL
		item_icon.texture_normal = item.data.image
		item_icon.texture_focused = item.data.image
		item_icon.texture_disabled = item.data.image
		item_icon.focus_entered.connect(set_selected.bind(item))
		if(item_icon):
			%InventoryGrid.add_child(item_icon)

#To be called before populate_item_grid() when UI opens
func clear_item_grid() -> void:
	for child in items_container.get_children():
		child.queue_free()
