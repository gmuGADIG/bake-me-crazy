class_name MarketItemUI extends ReferenceRect

@onready var food_sprite: TextureRect = %FoodSprite
@onready var price_label: Label = %PriceLabel
@onready var button: Button = %Button
@onready var stars := %Stars

@export var hover_scale := 1.1
@export var pressed_scale := 0.9
@export var duration := 0.3

@onready var original_scale = scale
@onready var the_button = %Button

## Set this timer to the press duration right when the button is pressed. We
## only want to show the pressed scale right when the button is pressed, but
## not necessarily *while* it is pressed (i.e. selected).
var pressed_timer: float = 0.0
var lambda: float = 0.0

func _ready() -> void:
	# Compute lambda for correct framerate-independent
	# lerp smoothing. See: https://pbs.twimg.com/media/GGUR6TVWQAATdwe?format=png&name=large
	lambda = -duration / (log(0.01) / log(2))
	
	%Button.toggled.connect(func(toggled_on: bool) -> void:
		if toggled_on:
			pressed_timer = duration * 0.5
	)

var star_textures: Array[Texture2D] = [
	null,
	preload("res://menus/market_ui/star_1.svg"),
	preload("res://menus/market_ui/star_2.svg"),
	preload("res://menus/market_ui/star_3.svg"),
]

func set_item(item: ShopItem) -> void:
	food_sprite.texture = item.data.image
	price_label.text = str("$", item.price)
	stars.texture = star_textures[clamp(item.quality, 0, 3)]
	
func _process(delta: float) -> void:
	# NOTE: Kinda sad that we recompute this, ideally it gets cached somewhere.
	var fac := 1.0 - pow(2.0, -delta / lambda)
	var target_scale := 1.0
	if pressed_timer > 0.0:
		target_scale *= pressed_scale
		pressed_timer -= delta
	elif the_button.is_hovered():
		# Use the button hover value to determine hover. This is so it matches
		# the button's hover style.
		target_scale *= hover_scale
		
	scale = lerp(scale, original_scale * target_scale, fac)
	
	
