extends Node

##This is the singleton used to store the current data state in runtime. This could probably be moved to the regular Player.gd

var data := SaveTemplate.new()

func _ready() -> void:
	Inventory.add_item(load("res://items/foods/cake_vanilla.tres"), 3)
	Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	var shop_item : ShopItem = ShopItem.new()
	shop_item.price = 0
	shop_item.quality = 3
	shop_item.data = load("res://items/ingredients/vanilla.tres")
	Inventory.buy_item(shop_item,10)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)
	#Inventory.add_item(load("res://items/foods/cake_chocolate.tres"), 2)

func load_file(save_template : SaveTemplate) -> void:
	data = save_template
	SceneTransition.change_scene_to_file(data.scene_path)
	Dialogic.load_full_state(data.dialogic_blob)
	# TODO: include the current scene in the save and go there
