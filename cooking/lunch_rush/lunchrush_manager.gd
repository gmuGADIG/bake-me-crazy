extends Node2D

class MouseData:
	var val : float
	var delta : float
	
	func _init(y : float, d : float) -> void:
		self.val = y
		self.delta = d

#TODO: Replace these with the actual food items and flavors
@export var foods : Array[FoodItem]
@export var flavors : Array[FoodItem]

#The amount of time in seconds for the UI to slide in/out
@export var ui_transition_time : float = 0.8

##Defines at what accelerative threshold should the shaker start working
@export var acceleration_threshold : int = 500
##Defines at what jerk (the change in acceleration) threshold should the shaker start working
@export var jerk_threshold : int = 1000

##Stores the position of the mouse for the past 8 frames 
var mouse_positions : Array[MouseData]


##What the customer wants, and what the player selects respectively
var requested_food : FoodItem
var requested_flavor : FoodItem

var selected_food : FoodItem
var selected_flavor : FoodItem


enum Stage {
	FOOD_SELECT,
	FLAVOR_SELECT,
	FLAVOR_TOWN
}

enum Finisher {
	NOT_SELECTED,
	SHAKER,
	DRIZZLE
}

var current_stage : Stage
var selected_finisher_type : Finisher

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	new_order()


func new_order() -> void:
	##Reset all node states to default
	current_stage = Stage.FOOD_SELECT
	selected_finisher_type = Finisher.NOT_SELECTED
	
	$DivorceWoman.modulate.a = 0
	$CanvasLayer/FoodSelect/VBoxContainer.position.x = 1162
	$CanvasLayer/FlavorSelect/VBoxContainer.position.x = 1162
	
	##Selects order
	requested_food = foods.pick_random()
	requested_flavor = flavors.pick_random()
	
	print("food: " + requested_food.display_name)
	print("flavour: " + requested_flavor.display_name)
	
	
	##Sets all of the images
	$CanvasLayer/FoodSelect/VBoxContainer/Food1.icon = foods[0].image
	$CanvasLayer/FoodSelect/VBoxContainer/Food2.icon = foods[1].image
	$CanvasLayer/FoodSelect/VBoxContainer/Food3.icon = foods[2].image
	$CanvasLayer/FoodSelect/VBoxContainer/Food4.icon = foods[3].image
	
	$CanvasLayer/FlavorSelect/VBoxContainer/Flavor1.icon = flavors[0].image
	$CanvasLayer/FlavorSelect/VBoxContainer/Flavor2.icon = flavors[1].image
	$CanvasLayer/FlavorSelect/VBoxContainer/Flavor3.icon = flavors[2].image
	
	$FoodRequest/RequestedFood.texture = requested_food.image
	$FoodRequest/RequestedFlavor.texture = requested_flavor.image
	
	
	
	
	##Make new person visible
	var tween = get_tree().create_tween()
	tween.tween_property($DivorceWoman, "modulate:a", 1, 0.8).set_trans(Tween.TRANS_EXPO)
	
	
	tween.tween_property($FoodRequest, "modulate:a", 1, 0.3).set_trans(Tween.TRANS_EXPO)
	##Food buttons slide in
	tween.parallel().tween_property($CanvasLayer/FoodSelect/VBoxContainer, "position:x", 1052, 0.8).set_trans(Tween.TRANS_QUAD)
	
	
	

func approx_derivative(m1 : MouseData	, m2 : MouseData) -> float:
	return (m2.val-m1.val)/(m2.delta*10.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if current_stage != Stage.FLAVOR_TOWN:
		return
	
	match selected_finisher_type:
		Finisher.SHAKER:
			shaker(delta)
		Finisher.DRIZZLE:
			drizzle(delta)
		
func drizzle(delta : float) -> void:
	if Input.is_mouse_button_pressed(1): # Left click
		print()
	pass

func shaker(delta : float) -> void:
	#var mouse_y_pos : int = 
	var new_mouse_pos : MouseData = MouseData.new(get_viewport().get_mouse_position().y, delta)
	mouse_positions.push_back(new_mouse_pos)
	if mouse_positions.size() > 4:
		mouse_positions.pop_front()
	
	
	if is_shaking_hard_enough():
		pass
	pass

func is_shaking_hard_enough() -> bool:
	##Runs if there is enough data to calculate jerk
	if mouse_positions.size() == 4:
		var mouse_vels : Array[MouseData]
		for i in range(1,4):
			var new_mouse_vel : MouseData = MouseData.new(approx_derivative(mouse_positions[i-1],mouse_positions[i]),mouse_positions[i].delta)
			mouse_vels.push_back(new_mouse_vel)
			
		var mouse_accs : Array[MouseData]
		for i in range(1,3):
			var new_mouse_acc : MouseData = MouseData.new(approx_derivative(mouse_vels[i-1],mouse_vels[i]),mouse_vels[i].delta)
			mouse_accs.push_back(new_mouse_acc)
			
		var t : float = approx_derivative(mouse_accs[0],mouse_accs[1])
		if t < -jerk_threshold and abs(mouse_accs[1].val) > acceleration_threshold and mouse_vels[2].val > 0:# Acc negative, velocity pos
			return true
	return false

##Each of the buttons in the inspector pass in an index argument for the foods array
func _on_food_selected(food_index: int) -> void:
	if current_stage != Stage.FOOD_SELECT:
		return
	
	current_stage = Stage.FLAVOR_SELECT
	
	selected_food = foods[food_index]
	print(selected_food)
	$FoodItem/Sprite2D.texture = selected_food.image
	
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/FoodSelect/VBoxContainer, "position:x", 1162, 0.3	).set_trans(Tween.TRANS_QUAD)
	#TODO: Make the food slide in at the same time as the food select disapears
	tween.tween_property($CanvasLayer/FlavorSelect/VBoxContainer, "position:x", 1052, 0.3).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property($FoodItem,"position:x", 576, 0.8).set_trans(Tween.TRANS_QUAD)
	

##Each of the buttons in the inspector pass in an index argument for the flavours array
func _on_flavor_selected(flavor_index: int) -> void:
	if current_stage != Stage.FLAVOR_SELECT:
		return
	
	current_stage = Stage.FLAVOR_TOWN
	
	selected_flavor = flavors[flavor_index]
	selected_finisher_type = select_finisher_type()
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/FlavorSelect/VBoxContainer, "position:x", 1162, 0.3).set_trans(Tween.TRANS_QUAD)
	
	pass
	
func select_finisher_type() -> Finisher:
	match selected_flavor.type:
		FoodItem.Type.BLUEBERRY_SAUCE:
			return Finisher.DRIZZLE
		FoodItem.Type.KETCHUP:
			return Finisher.DRIZZLE
		FoodItem.Type.PESTO:
			return Finisher.SHAKER
		_:
			return -1
		
