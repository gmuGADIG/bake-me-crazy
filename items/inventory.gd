class_name Inventory extends Node

### All methods are static; actual data is stored in PlayerData.data.inventory

## Returns true if the player has enough money for the given item.
static func can_afford_item(shop_item: ShopItem, quantity: int) -> bool:
	return PlayerData.data.money >= shop_item.price * quantity

## Adds the item to the player's inventory and takes away the price from the player's money.
## The player must have enough money when calling this function. See `can_afford_item`
static func buy_item(shop_item: ShopItem, quantity: int) -> void:
	assert(can_afford_item(shop_item, quantity))
	for _i in range(quantity):
		add_item(shop_item.data, shop_item.quality)
		PlayerData.data.money -= shop_item.price

## Adds a single instance of an item to the player's inventory.
## Doesn't care about money.
## This is intended to be called when the player makes a food and adds it to their inventory.
static func add_item(item_data: ItemData, quality: int) -> void:
	var item_instance = ItemInstance.new()
	item_instance.setup(item_data, quality)
	PlayerData.data.inventory.append(item_instance)

## Takes an item of the given type out of the inventory.
## If multiple of this item are present, returns the one with the highest quality.
## If none are present, returns null.
static func pop_item(item_data: ItemData) -> ItemInstance:
	var items := PlayerData.data.inventory
	var best_index = -1
	for i in range(1, items.size()):
		if items[i].data != item_data: continue
		if best_index == -1:
			best_index = i
			continue
		if items[i].quality > items[best_index].quality:
			best_index = i
	
	if best_index == -1: return null
	else: return PlayerData.data.inventory.pop_at(best_index)

## Takes the item at the given index out of the inventory.
## `index` must be a valid index in the inventory.
static func pop_item_at(index: int) -> ItemInstance:
	assert(index >= 0 and PlayerData.data.inventory.size() > index)
	return PlayerData.data.inventory.pop_at(index)

static func remove_specific_item(item_instance: ItemInstance) -> void:
	PlayerData.data.inventory.remove_at(PlayerData.data.inventory.find(item_instance))

## Gets the count of how many of a specific item we have in the inventory.
static func get_item_count(item_data: ItemData) -> int:
	var count := 0
	var items := PlayerData.data.inventory
	for i in range(items.size()):
		if items[i].data == item_data:
			count += 1
	return count
