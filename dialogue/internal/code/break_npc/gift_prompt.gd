extends VBoxContainer

func _ready() -> void:
	for item in PlayerData.data.inventory:
		if item.data is not FoodData: continue
		
		var button = Button.new()
		button.text = "Gift %s" % [item.data.display_name]
		button.pressed.connect(_on_food_option_pressed.bind(item))
		add_child(button)

func _on_cancel_button_pressed() -> void:
	Dialogic.VAR.read_only.gift_response = "canceled"
	queue_free()

func _on_food_option_pressed(food: ItemInstance) -> void:
	# set 'gift_response' to the flavor name, or "no_flavor" if null
	var flavor = food.data.ingredient as IngredientData
	if flavor == null:
		Dialogic.VAR.read_only.gift_response = "no_flavor"
	else:
		Dialogic.VAR.read_only.gift_response = flavor.display_name.to_lower()
	
	# set quality
	Dialogic.VAR.read_only.gift_quality = food.quality
	
	# remove gifted item from inventory
	Inventory.remove_specific_item(food)
	
	queue_free()
