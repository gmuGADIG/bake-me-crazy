extends Node

#Dictionary of <Item_Data, int (quantity)>
var playerInventory = {}

@export var money: int = 0:
	get: return money
	set(value): money = value

# Recipes and Items should be resources
# Methods: buy, bake item, 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func add_item(item: Item_Data, quantity: int = 1) -> void:
	if(playerInventory.has(item)):
		playerInventory[item] += quantity
	else:
		playerInventory[item] = quantity

func remove_item(item: Item_Data, quantity: int = 1) -> void:
	if(playerInventory.has(item) and playerInventory[item] >= quantity):
		playerInventory[item] -= quantity
	if(playerInventory[item]==0):
		playerInventory.erase(item)

#Possibly use boolean instead
func buy_item(item: Item_Data, quantity: int = 1) -> void:
	if(money>=item.price*quantity):
		add_item(item, quantity)
		money -= item.price*quantity

func bake_item() -> void:
	
	pass
