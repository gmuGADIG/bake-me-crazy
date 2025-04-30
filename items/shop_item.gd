class_name ShopItem extends Resource

## Money required to buy one
@export var price: int = 0

## Quality of the item, from 1 to 3 stars
@export var quality: int = 1

## Item to be purchased
@export var data: IngredientData
