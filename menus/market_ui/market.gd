extends CanvasLayer

@export var items: Array[ItemData]

@onready var ingredient_container: FlowContainer = %IngredientContainer

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

func select_item(item: ItemData) -> void:
	print("selected item `%s`" % item.code_name)
