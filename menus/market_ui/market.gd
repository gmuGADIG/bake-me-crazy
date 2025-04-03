extends CanvasLayer

@export var items: Array[ItemData]

@onready var ingredient_container: FlowContainer = %IngredientContainer

@onready var quantity_number := %QuantityNumber
@onready var total_price := %TotalPrice

var current_item: ItemData = null

## Keeps the purchase count from going above this value. This is potentially
## a decent idea because it means the game will never behave unpredictably.
const ABSOLUTE_ITEM_MAX: int = 99

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

var _purchase_quantity: int = 0

func _ready() -> void:
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
	_update_purchase_display()
	%LeftArrow.pressed.connect(func():
		_purchase_quantity -= 1
		if _purchase_quantity < 0:
			_purchase_quantity = 0
		_update_purchase_display()
		_tween_quantity_number()
	)
	
	%RightArrow.pressed.connect(func():
		_purchase_quantity += 1
		if _purchase_quantity > ABSOLUTE_ITEM_MAX:
			_purchase_quantity = ABSOLUTE_ITEM_MAX
		# TODO: Is there a maximum quantity?
		_update_purchase_display()
		_tween_quantity_number()
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

func _update_purchase_display():
	quantity_number.text = str(_purchase_quantity)
	total_price.text = str("$", _get_current_purchase_price())
	
func _tween_quantity_number() -> void:
	var tween := create_tween()
	tween.tween_property(quantity_number, "scale", Vector2.ONE * 1.14, 0.1)
	tween.tween_property(quantity_number, "scale", Vector2.ONE       , 0.3)

func select_item(item: ItemData) -> void:
	print("selected item `%s`" % item.code_name)
	current_item = item
	# Must change the display when we change the item.
	_update_purchase_display()
	
