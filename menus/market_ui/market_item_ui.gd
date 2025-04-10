class_name MarketItemUI extends ReferenceRect

@onready var food_sprite: TextureRect = %FoodSprite
@onready var price_label: Label = %PriceLabel
@onready var button: Button = %Button
@onready var stars := %Stars

var star_textures: Array[Texture2D] = [
	null,
	preload("res://menus/market_ui/star_1.svg"),
	preload("res://menus/market_ui/star_2.svg"),
	preload("res://menus/market_ui/star_3.svg"),
]

func set_item(item: ItemData) -> void:
	food_sprite.texture = item.icon
	price_label.text = str("$", item.price)
	stars.texture = star_textures[clamp(item.quality, 0, 3)]
	
