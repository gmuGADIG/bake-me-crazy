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

@export var shaker_particle : PackedScene
@export var drizzle_particle : PackedScene

##Number of customers in a single lunch rush
@export var total_customers : int = 5

#The amount of time in seconds for the UI to slide in/out
@export var ui_transition_time : float = 0.8

##Defines at what accelerative threshold should the shaker start working
@export var acceleration_threshold : int = 500
##Defines at what jerk (the change in acceleration) threshold should the shaker start working
@export var jerk_threshold : int = 1000
@export var finisher_raycast_length : int = 250 ## The length of the downward raycast when checking for drizzles and shakers

##The length of the raycast made to check if the shaker is over the food
@export var shaker_distance : int = 500

##Stores the position of the mouse for the past 8 frames 
var mouse_positions : Array[MouseData]


##What the customer wants, and what the player selects respectively
var requested_food : FoodItem
var requested_flavor : FoodItem

var selected_food : FoodItem
var selected_flavor : FoodItem


var current_customer : int = 0
var total_tip : float
 


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

## Elapsed time as food is made, for scoring
var elapsed_time : float = 0.0
## Controls when the timer is processed
var timer_active : bool = false
## The most any customer will tip, what the player earns for each item in the best case scenario
@export var maximum_tip : float = 5.0
@export var penalty_per_mess_up : float = 2.0 ##The amount of $ for getting a food or finisher wrong


@export var percent_gained_per_shake : float 
@export var percent_gained_per_drizzle : float 

##End goal for the finishers is 100.0%
var current_finisher_percentage : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	new_order()


func new_order() -> void:
	##Reset all node states to default
	current_stage = Stage.FOOD_SELECT
	selected_finisher_type = Finisher.NOT_SELECTED
	
	$FinisherSprite.texture = null
	$FoodItem.position.x = -150
	$DivorceWoman.modulate.a = 0
	$CanvasLayer/FoodSelect/VBoxContainer.position.x = 1162
	$CanvasLayer/FlavorSelect/VBoxContainer.position.x = 1162
	$CanvasLayer/FinishOrder.position.x = -100
	
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
	
	$FoodItem/FoodItemSprite/Sauce.visible = false
	$FoodItem/FoodItemSprite/Dust.visible = false
	current_finisher_percentage = 0.0
	
	
	##Make new person visible
	var tween = get_tree().create_tween()
	tween.tween_property($DivorceWoman, "modulate:a", 1, 0.8).set_trans(Tween.TRANS_EXPO)
	
	
	tween.tween_property($FoodRequest, "modulate:a", 1, 0.3).set_trans(Tween.TRANS_EXPO)
	##Food buttons slide in
	tween.parallel().tween_property($CanvasLayer/FoodSelect/VBoxContainer, "position:x", 1052, 0.8).set_trans(Tween.TRANS_QUAD)
	
	## Reset and start the timer!
	elapsed_time = 0.0
	timer_active = true
	
	

func approx_derivative(m1 : MouseData	, m2 : MouseData) -> float:
	return (m2.val-m1.val)/(m2.delta*10.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if current_stage != Stage.FLAVOR_TOWN:
		return
	
	##Make the shaker follow the mouse
	$FinisherSprite.position = get_viewport().get_mouse_position()
	
	match selected_finisher_type:
		Finisher.SHAKER:
			shaker(delta)
		Finisher.DRIZZLE:
			drizzle(delta)
		
func drizzle(delta : float) -> void:
	if Input.is_mouse_button_pressed(1): # Left click
		
		##Create Drizzle Particle
		var new_particle : GPUParticles2D = drizzle_particle.instantiate()
		$FinisherSprite.add_child(new_particle)
		new_particle.emitting = true
		
		if above_food():
			print("drizz")
			current_finisher_percentage = move_toward(current_finisher_percentage, 100.0, percent_gained_per_drizzle)
			
			##Visible Sauce application feedback
			$FoodItem/FoodItemSprite/Sauce.visible = true
			$FoodItem/FoodItemSprite/Sauce.scale = Vector2(current_finisher_percentage/100.0,current_finisher_percentage/100.0)
	pass

func shaker(delta : float) -> void:
	#var mouse_y_pos : int = 
	var new_mouse_pos : MouseData = MouseData.new(get_viewport().get_mouse_position().y, delta)
	mouse_positions.push_back(new_mouse_pos)
	if mouse_positions.size() > 4:
		mouse_positions.pop_front()
	
	
	if is_shaking_hard_enough():
		##Create the particle effect
		var new_particle : GPUParticles2D = shaker_particle.instantiate()
		$FinisherSprite.add_child(new_particle)
		new_particle.emitting = true
		
		if above_food():
			print("shake")
			current_finisher_percentage = move_toward(current_finisher_percentage, 100.0, percent_gained_per_shake)
			
			##Visible Sauce application feedback
			$FoodItem/FoodItemSprite/Dust.visible = true
			print(current_finisher_percentage)
			$FoodItem/FoodItemSprite/Dust.scale = Vector2(current_finisher_percentage/100.0,current_finisher_percentage/100.0)
				
	pass
	

func above_food()-> bool:
	var space_state = get_world_2d().direct_space_state
	#use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(get_viewport().get_mouse_position(), get_viewport().get_mouse_position()+Vector2(0,finisher_raycast_length))
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if result.size() > 0:
		return true
	else:
		return false



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
	$FoodItem/FoodItemSprite.texture = selected_food.image
	
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
	$FinisherSprite.texture = selected_flavor.image
	selected_finisher_type = select_finisher_type()
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/FlavorSelect/VBoxContainer, "position:x", 1162, 0.3).set_trans(Tween.TRANS_QUAD)
	tween.set_parallel().tween_property($CanvasLayer/FinishOrder, "position:x", 0, 0.3).set_trans(Tween.TRANS_QUAD)
	
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

## This process function is only here for the timer, at least at the moment. It's not in physics process because that's bad practice, and the timer isn't directly in process because that's also bad practice.
func _process(delta) -> void:
	if timer_active: processTimer(delta)

func processTimer(delta) -> void:
	elapsed_time+=delta

func scoreFood() -> float:
	#	SCORE CRITERIA:
	#	- TIME SPENT
	#	- ACCURACY TO REQUEST
	#	- COVERAGE OF SAUCE
	## We start counting a penalty that we add to for everything the player got wrong.
	var penalty: float = 0.0
	
	#TODO: Balance these penalties. Currently you start with $5.0, lose $2.0 for each broken request, and lose $.05 per second spent.
	if selected_food.type!=requested_food.type: penalty += penalty_per_mess_up
	
	
	## Penalize picking the wrong flavor.
	if selected_flavor.type!=requested_flavor.type:
		penalty += penalty_per_mess_up
	else:
		## It's not enough to pick the right flavor. Penalize based on how much coverage was missed.
		penalty += maxf(0,((100.0-current_finisher_percentage)/100)*penalty_per_mess_up)
	## Penalize for time, currently 5 cents per second. Currently, time is always being deducted. We could add a quick check and not penalize at all if the player is fast enough, but as it stands you're at least losing a few nickels.
	penalty+=elapsed_time/20

	## We take the penalty we calculated and subtract it from how much the customer will tip. We assume each customer will ideally tip the same maximum_tip export variable.
	var rewarded_tip: float = maximum_tip
	rewarded_tip -= penalty
	if rewarded_tip<0: rewarded_tip==0
	## We take that final tip and return it wherever the function was called.
	return rewarded_tip

	


func _on_finish_order() -> void:
	## Stop the clock!
	timer_active = false
	if current_stage != Stage.FLAVOR_TOWN:
		return
		
	total_tip += scoreFood()
	current_customer+=1
	print(current_customer)
	
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/FinishOrder, "position:x", -100, 0.3).set_trans(Tween.TRANS_QUAD)
	tween.set_parallel().tween_property($DivorceWoman, "modulate:a", 0, 0.8)
	tween.set_parallel().tween_property($FoodRequest, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_EXPO)
	## If the player has served all customers, end the lunch rush
	if current_customer >= total_customers:
		get_tree().change_scene_to_file("res://menus/start_menu/main_menu.tscn")
		return
		##end here
	new_order()
