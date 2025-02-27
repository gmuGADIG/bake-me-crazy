extends Node
## Represents a single item in the food minigame.
class_name FoodItem

@onready var sprite = $Sprite

## Instantiates a FoodItem with the given texture.
static func create_textured_food(texture: Texture2D) -> FoodItem:
	var item: FoodItem = preload("res://cooking/food_item.tscn").instantiate()
	
	item.get_node("Sprite").texture = texture
	
	return item
	
