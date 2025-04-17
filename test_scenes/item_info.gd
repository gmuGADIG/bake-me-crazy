extends Control

@onready var item_texture = $HBoxContainer/ItemTexture
@onready var item_label = $HBoxContainer/ItemLabel
@onready var quantity_label = $HBoxContainer/QuantityLabel


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

#Applies item data and quantity to control nodes.
func set_item_slot_data(item_data: ItemData) -> void:
	item_texture.texture = item_data.icon
	item_label.text = item_data.name
	quantity_label.text = InventorySystem.player_inventory[item_data]
	pass
