class_name PlayerInventory extends Node

### this is an AUTOLOAD/GLOBAL

#Dictionary of <Item_Data, int (quantity)>
var player_inventory = {}

@export var money: int = 0

# Recipes and Items should be resources
# Methods: buy, bake item, 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func add_item(item: ItemData, quantity: int = 1) -> void:
	if(player_inventory.has(item)):
		player_inventory[item] += quantity
	else:
		player_inventory[item] = quantity

func remove_item(item: ItemData, quantity: int = 1) -> void:
	if(player_inventory.has(item) and player_inventory[item] >= quantity):
		player_inventory[item] -= quantity
	if(player_inventory[item]==0):
		player_inventory.erase(item)

#Possibly use boolean instead
func buy_item(item: ItemData, quantity: int = 1) -> void:
	if(money>=item.price*quantity):
		add_item(item, quantity)
		money -= item.price*quantity

func bake_item() -> void:
	
	pass
