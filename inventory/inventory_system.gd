class_name PlayerInventory extends Node

### All methods are static; actual data is stored in PlayerData.data.inventory

## Returns true if the player has enough money for the given item.
static func can_afford_item(item: ItemData, quantity: int) -> bool:
	return PlayerData.data.money >= item.price * quantity

## Adds the item to the player's inventory and takes away the price from the player's money.
## The player must have enough money when calling this function. See `can_afford_item`
static func buy_item(item: ItemData, quantity: int) -> void:
	assert(can_afford_item(item, quantity))
	for _i in range(0, quantity):
		PlayerData.data.inventory.append(item)
		PlayerData.data.money -= item.price

## Takes an item of the given name out of the inventory.
## If multiple of this item are present, returns the one with the highest quality.
## If none are present, returns null.
static func pop_item(item_name: String) -> ItemData:
	var items := PlayerData.data.inventory
	var best_index = 0
	for i in range(1, items.size()):
		if items[i].code_name != item_name: continue
		if items[i].quality > items[best_index].quality:
			best_index = i
	
	if best_index == -1: return null
	else: return PlayerData.data.inventory.pop_at(best_index)
