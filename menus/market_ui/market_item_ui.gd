class_name MarketItemUI extends ReferenceRect

@onready var food_sprite: TextureRect = %FoodSprite
@onready var price_label: Label = %PriceLabel
@onready var button: Button = %Button

func set_item(item: ItemData) -> void:
	food_sprite.texture = item.icon
	price_label.text = str(item.price)
