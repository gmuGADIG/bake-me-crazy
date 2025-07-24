extends CanvasLayer
class_name MarketUI

@export var items: Array[ShopItem]
@export var neutral_portrait: Texture2D
@export var happy_portrait: Texture2D

@onready var ingredient_container: FlowContainer = %IngredientContainer

@onready var quantity_number := %QuantityNumber
@onready var total_price := %TotalPrice

var current_item: ShopItem = null

@onready var description_box := %Description
@onready var buy_button := %BuyButton

@onready var your_money := %YourMoney
@onready var portrait: TextureRect = $Control/Panel/TopStuff/Portrait

## Keeps the purchase count from going above this value. This is potentially
## a decent idea because it means the game will never behave unpredictably.
const ABSOLUTE_ITEM_MAX: int = 9

## Gets the per-item price of the currently selected item, if there is one. If
## no item is selected, returns 0.
func _get_current_per_item_price() -> int:
	if current_item == null:
		return 0
	return current_item.price
	
## Gets the current total price of the purchase. This equals the per-item price
## times the desired number of items.
func _get_current_purchase_price() -> int:
	return _get_current_per_item_price() * _purchase_quantity

var _purchase_quantity: int = 1

func _ready() -> void:
	portrait.texture = neutral_portrait
	
	var button_group = ButtonGroup.new()
	for i in range(ingredient_container.get_child_count()):
		var item_button: MarketItemUI = ingredient_container.get_child(i)
		if i >= items.size():
			item_button.visible = false
		else:
			item_button.set_item(items[i])
			item_button.button.button_group = button_group
			item_button.button.pressed.connect(func():
				select_item(items[i])
			)
			
	# Initialize various displays.
	_update_item_displays()
	%LeftArrow.pressed.connect(func():
		_purchase_quantity -= 1
		_purchase_quantity = clamp(_purchase_quantity, 1, ABSOLUTE_ITEM_MAX)
		_update_item_displays()
		_tween_quantity_number()
	)
	
	%RightArrow.pressed.connect(func():
		_purchase_quantity += 1
		_purchase_quantity = clamp(_purchase_quantity, 1, ABSOLUTE_ITEM_MAX)
		# TODO: Is there a maximum quantity?
		_update_item_displays()
		_tween_quantity_number()
	)
	
	buy_button.pressed.connect(func():
		Inventory.buy_item(current_item, _purchase_quantity)
		portrait.texture = happy_portrait
		%JumpPortrait.play(&"jump_portrait")
		_update_item_displays()
		_tween_box_scale(%YourMoneyPanel, 1.14)
		_tween_box_scale(%YourMoneyDollar, 1.14)
	)
	
	%CancelButton.pressed.connect(func():
		# NOTE: This will also queue_free() the UI. Disable the cancel button
		# so we can't press it again. (Also the buy button, because why not).
		%CancelButton.disabled = true
		%BuyButton.disabled = true
		%AnimationPlayer.play("swipe_out")
	)
	
	# Select one of the buttons. NOTE: This assumes that ingredient_container
	# has childrern, which is also the assumption made by the code above (essentially).
	var first: MarketItemUI = ingredient_container.get_child(0)
	if first.visible:
		# Note: This WILL NOT also select the item! We have to manually do that,
		# even though the signal is connected. TODO: Why doesn't the signal fire..?
		first.button.button_pressed = true
		# The cleanest way to do this is to just manually tell it to emit the pressed
		# signal?
		first.button.pressed.emit()
	
func _update_item_displays():
	# Update the item quantity
	quantity_number.text = str(_purchase_quantity)
	total_price.text = str("$", _get_current_purchase_price())
	
	# Update description box
	description_box.text = "<nothing selected>"
	if current_item != null:
		description_box.text = current_item.data.display_name + "\n" + current_item.data.description
	
	# Update your money
	your_money.text = str(PlayerData.data.money)
	
	buy_button.disabled = (PlayerData.data.money < _get_current_purchase_price())
	
func _tween_box_scale(node: Control, to_scale: float = 1.14) -> void:
	var tween := create_tween()
	tween.tween_property(node, "scale", Vector2.ONE * to_scale, 0.1)
	tween.tween_property(node, "scale", Vector2.ONE           , 0.3)
	
func _tween_quantity_number() -> void:
	_tween_box_scale(quantity_number, 1.14)

func select_item(item: ShopItem) -> void:
	print("selected item `%s`" % item.data.display_name)
	current_item = item
	# Must change the display when we change the item.
	_update_item_displays()
	
