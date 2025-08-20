extends Node2D

class MouseData:
	var val : float
	var delta : float
	
	func _init(y : float, d : float) -> void:
		self.val = y
		self.delta = d

@onready var drizzle_line: DrizzleLine = $DrizzleLine
@onready var npc_holder: Node2D = %NPCHolder
@onready var food_container: VBoxContainer = %FoodContainer
@onready var flavor_container: VBoxContainer = %FlavorContainer
@onready var money_label: RichTextLabel = %Money
@onready var view_anim: AnimationPlayer = %ViewAnim
@onready var dust_manager: DustManager = %DustManager
@onready var finisher_progress_bar: ProgressBar = %FinisherProgressBar

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
@export var finisher_raycast_length : int = 500 ## The length of the downward raycast when checking for drizzles and shakers
##The length of the raycast made to check if the shaker is over the food
@export var shaker_distance : int = 500

##Stores the position of the mouse for the past 8 frames 
var mouse_positions : Array[MouseData]


##What the customer wants, and what the player selects respectively
var requested_food : FoodItem
var requested_flavor : FoodItem

var selected_food : FoodItem
var selected_flavor : FoodItem

var current_npc : LunchRushNPC
var current_customer : int = 0
var total_tip : float
 
signal drizzle_started

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
var current_finisher_percentage : float:
	set(v):
		current_finisher_percentage = v
		
		if v == 0:
			finisher_progress_bar.modulate.a = 0.
		elif finisher_progress_bar.modulate.a == 0.:
			create_tween().tween_property(finisher_progress_bar, "modulate:a", 1., 1.)
		
		finisher_progress_bar.value = v


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_order()


func new_order() -> void:
	## Reset all node states to default
	current_stage = Stage.FOOD_SELECT
	selected_finisher_type = Finisher.NOT_SELECTED
	
	## Selects order
	requested_food = foods.pick_random()
	requested_flavor = flavors.pick_random()
	
	## Spawn NPC
	current_npc = preload("lunch_rush_npc.tscn").instantiate()
	npc_holder.add_child(current_npc)
	current_npc.set_food(requested_food, requested_flavor)

	## Reset buttons	
	$FinisherSprite.texture
	food_container.position.x = 1162
	flavor_container.position.x = 1162
	$CanvasLayer/FinishOrder.position.x = -120
	

	## Sets all of the images
	for i in range(food_container.get_child_count()):
		food_container.get_child(i).icon = foods[i].image

	for i in range(flavor_container.get_child_count()):
		flavor_container.get_child(i).icon = flavors[i].image
	
	$FoodRequest/RequestedFood.texture = requested_food.image
	$FoodRequest/RequestedFlavor.texture = requested_flavor.image
	
	$FoodItem/FoodItemSprite/Sauce.visible = false
	$FoodItem/FoodItemSprite/Dust.visible = false
	dust_manager.position = 0.
	current_finisher_percentage = 0.0
	
	
	##Make new person visible
	var tween = get_tree().create_tween()
	#tween.tween_property($DivorceWoman, "modulate:a", 1, 0.8).set_trans(Tween.TRANS_EXPO)
	
	
	tween.tween_property($FoodRequest, "modulate:a", 1, 0.3).set_trans(Tween.TRANS_EXPO)
	##Food buttons slide in
	tween.parallel().tween_property(food_container, "position:x", 1025, 0.8).set_trans(Tween.TRANS_QUAD)
	
	## Reset and start the timer!
	elapsed_time = 0.0
	timer_active = true
	
	

func approx_derivative(m1 : MouseData	, m2 : MouseData) -> float:
	return (m2.val-m1.val)/(m2.delta*10.0)

# true if the previous physics frame was both in stage FLAVOR_TOWN and
# the user was holding down the mouse button and if the mouse was over
# the food
var new_line := true

func _physics_process(delta: float) -> void:
	if current_stage != Stage.FLAVOR_TOWN:
		new_line = true
		return
	
	if Input.is_action_pressed("minigame_interact") and not new_line:
		new_line = false
	elif not Input.is_action_just_pressed("minigame_interact"):
		new_line = true
	
	##Make the shaker follow the mouse
	$FinisherSprite.position = get_viewport().get_mouse_position()
	
	match selected_finisher_type:
		Finisher.SHAKER:
			shaker(delta)
		Finisher.DRIZZLE:
			drizzle(delta)
		
func drizzle(delta : float) -> void:
	if Input.is_mouse_button_pressed(1): # Left click
		var height_arr := above_food()
		if height_arr:
			var tool_tip_pos := get_local_mouse_position() + Vector2.DOWN * 80
			var ray_height := height_arr[0]
			var food_item_y: float = %FoodItem.position.y
			var food_bottom_y := food_item_y + 35
			var food_top_y := food_item_y - 41
			
			# convert ray_height to point on food
			ray_height -= 65
			ray_height = max(0, ray_height)
			
			var fall_target := food_bottom_y - ray_height * .5
			fall_target = max(fall_target, food_top_y)
			var fall_height := fall_target - tool_tip_pos.y
			
			drizzle_line.add_point(
				tool_tip_pos, 
				fall_height / DrizzleLine.GRAVITY,
				new_line
			)
			
			new_line = false
			current_finisher_percentage = move_toward(
				current_finisher_percentage, 
				100.0, 
				percent_gained_per_drizzle
			)
		
		##Create Drizzle Particle
		#drizzle_started.emit()
		#var new_particle : GPUParticles2D = drizzle_particle.instantiate()
		#$FinisherSprite.add_child(new_particle)
		#print(selected_flavor.display_name)
		#if (selected_flavor.display_name == "Chocolate Topping"):
			#print("hello")
			#new_particle.process_material.color = Color.SIENNA
		#new_particle.emitting = true
		#
		#if above_food():
			#print("drizz")
			#current_finisher_percentage = move_toward(current_finisher_percentage, 100.0, percent_gained_per_drizzle)
			#
			###Visible Sauce application feedback
			#$FoodItem/FoodItemSprite/Sauce.visible = true
			#$FoodItem/FoodItemSprite/Sauce.scale = Vector2(current_finisher_percentage/100.0,current_finisher_percentage/100.0)
			#if (selected_flavor.display_name == "Chocolate Topping"):
				#$FoodItem/FoodItemSprite/Sauce.modulate = Color.SIENNA
		else:
			new_line = true
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
		new_particle.scale = Vector2.ONE * 5.
		$FinisherSprite.add_child(new_particle)
		new_particle.emitting = true
		
		if above_food():
			print("shake")
			current_finisher_percentage = move_toward(current_finisher_percentage, 100.0, percent_gained_per_shake)
			
			##Visible Sauce application feedback
			$FoodItem/FoodItemSprite/Dust.visible = true
			print(current_finisher_percentage)
			dust_manager.position += 0.015
			#$FoodItem/FoodItemSprite/Dust.scale = Vector2(current_finisher_percentage/100.0,current_finisher_percentage/100.0)
			
	pass
	


func above_food()-> Array[float]:
	var space_state = get_world_2d().direct_space_state
	#use global coordinates, not local to node
	var src_pos := get_global_mouse_position() + Vector2.DOWN * 80
	var query = PhysicsRayQueryParameters2D.create(src_pos, get_viewport().get_mouse_position()+Vector2(0,finisher_raycast_length))
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if result.size() > 0:
		var height: float = result.position.y - src_pos.y
		return [height]
	else:
		return []



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
	$FoodItem.modulate.a = 1.0
	$FoodItem.position.x = -150
	
	var tween = get_tree().create_tween()
	tween.tween_property(food_container, "position:x", 1162, 0.3	).set_trans(Tween.TRANS_QUAD)
	#TODO: Make the food slide in at the same time as the food select disapears
	tween.tween_property(flavor_container, "position:x", 1025, 0.3).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property($FoodItem,"position:x", 576, 0.8).set_trans(Tween.TRANS_QUAD)
	

##Each of the buttons in the inspector pass in an index argument for the flavours array
func _on_flavor_selected(flavor_index: int) -> void:
	if current_stage != Stage.FLAVOR_SELECT:
		return
	
	current_stage = Stage.FLAVOR_TOWN
	
	view_anim.play("expand_table")
	
	selected_flavor = flavors[flavor_index]
	$FinisherSprite.modulate.a = 1.
	$FinisherSprite.texture = selected_flavor.image
	selected_finisher_type = select_finisher_type()
	var tween = get_tree().create_tween()
	tween.tween_property(flavor_container, "position:x", 1162, 0.3).set_trans(Tween.TRANS_QUAD)
	tween.set_parallel().tween_property($CanvasLayer/FinishOrder, "position:x", 100, 0.3).set_trans(Tween.TRANS_QUAD)
	
func select_finisher_type() -> Finisher:
	drizzle_line.clear_points()
	match selected_flavor.type:
		FoodItem.Type.CHOCOLATE_TOPPING:
			finisher_progress_bar.modulate = Color.SIENNA
			drizzle_line.modulate = Color.SIENNA
			return Finisher.DRIZZLE
		FoodItem.Type.CHERRY_TOPPING:
			finisher_progress_bar.modulate = Color.HOT_PINK
			drizzle_line.modulate = Color.HOT_PINK
			return Finisher.DRIZZLE
		FoodItem.Type.POWDERED_SUGAR:
			finisher_progress_bar.modulate = Color.GHOST_WHITE
			return Finisher.SHAKER
		_:
			return -1

## This process function is only here for the timer, at least at the moment. It's not in physics process because that's bad practice, and the timer isn't directly in process because that's also bad practice.
func _process(delta) -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed("debug_skip"):
		SceneTransition.change_scene_to_file("res://menus/clock_out/clock_out.tscn")
	if timer_active: processTimer(delta)

func processTimer(delta) -> void:
	elapsed_time+=delta

func score_food() -> void:
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
	rewarded_tip = max(round(rewarded_tip), 1)
	
	## Remove food sprite
	create_tween().tween_property($FoodItem, "modulate:a", 0.0, 0.5)
	create_tween().tween_property(drizzle_line, "modulate:a", 0.0, 0.5)
	
	## Display money earned
	money_label.text = "[wave amp=70][b]$%d" % rewarded_tip
	money_label.get_node("Anim").play("earn")
	
	## Add to money
	PlayerData.data.money += rewarded_tip


func _on_finish_order() -> void:
	## Stop the clock!
	timer_active = false
	if current_stage != Stage.FLAVOR_TOWN:
		return
		
	score_food()
	current_customer += 1
	print(current_customer)
	
	view_anim.play_backwards("expand_table")
	current_npc.exit()
	
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/FinishOrder, "position:x", -120, 0.5).set_trans(Tween.TRANS_QUAD)
	tween.set_parallel().tween_property($FoodRequest, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($FinisherSprite, "modulate:a", 0., .5).set_trans(Tween.TRANS_EXPO)
	
	await view_anim.animation_finished
	
	## New order, or change scene if all customers have been served
	if current_customer >= total_customers:
		SceneTransition.change_scene_to_file("res://menus/clock_out/clock_out.tscn")
	else:
		new_order()
