extends FoodStep

@export var percent_piped_per_pixel_per_second : float = 10
@export var piping_bag_idle_pos : Vector2
@export var piping_bag_using_pos : Vector2

@export var target_piping_speed : float = 0.5
@export var target_tolerance : float = 0.2

var num_in_target : int
var num_out_of_target : int

@onready var full_puff_roll_sprite : Sprite2D = $PuffRoll/Sprites/PastryFull
@onready var glazed_sweet_roll_sprite : Sprite2D = $SweetRoll/Sprites/GlazedRoll

var food_type : FoodData.FoodType
var percent_piped : float = 0.0 ##Ranges between 0 and 100

var last_mouse_pos : Vector2
@export var drag_distance_average_amount : int = 10 ##The size of rolling_drag_distance needed to calculate the average drag distance. More = larger delay when first piping 
var recent_drag_distances : Array[float]

var clicking : bool



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var recipe : FoodData = MorningShift.instance.current_recipe if MorningShift.instance != null else null
	##Define the type here if you don't want to keep walking through the street during debug (for testing)
	if recipe == null:
		recipe = load("res://items/foods/sweet_roll_cinnamon.tres")
	
	assert(
		recipe.food_type == FoodData.FoodType.SWEET_ROLL || recipe.food_type == FoodData.FoodType.PUFF_ROLL,
		"This step is invalid for the given food type"
	)
	
	set_visuals(recipe)
	
	#print(MorningShift.instance.current_recipe.ingredient)
	pass
	#var arr : Array[float] = [1,2,3,4,5,6,7,8]
	#var m : Material = $Glaze.material
	#m.set_shader_parameter("values",arr)
	#pass # Replace with function body.


func set_visuals(recipe : FoodData) -> void:
	food_type = recipe.food_type
	if food_type == FoodData.FoodType.SWEET_ROLL:
		glazed_sweet_roll_sprite.texture = recipe.image
		$SweetRoll.show()
		$PuffRoll.hide()
	elif food_type == FoodData.FoodType.PUFF_ROLL:
		full_puff_roll_sprite.texture = recipe.image
		$SweetRoll.show()
		$SweetRoll.hide()
	else:
		assert(false,"There are no sprites for this given food type")

func _input(event: InputEvent) -> void:
	if event.is_action("minigame_interact"):
		if event.is_pressed():
			var tween : Tween = get_tree().create_tween()
			tween.tween_property($PipingBag,"position",piping_bag_using_pos,0.25).set_trans(Tween.TRANS_QUAD)
			last_mouse_pos = get_global_mouse_position()
			clicking = true
		elif event.is_released():
			var tween : Tween = get_tree().create_tween()
			tween.tween_property($PipingBag,"position",piping_bag_idle_pos,0.25).set_trans(Tween.TRANS_QUAD)
			recent_drag_distances.clear()
			clicking = false

func _process(delta: float) -> void:
	if clicking:
		var new_mouse_pos : Vector2 = get_global_mouse_position()
		var drag_dist : float = new_mouse_pos.y-last_mouse_pos.y
		var amount_piped : float = max(drag_dist*percent_piped_per_pixel_per_second*delta,0)
		percent_piped = move_toward(percent_piped,100.0,amount_piped)
		last_mouse_pos = new_mouse_pos
		
		##Visual Feedback
		$PipingBag.display_icing(percent_piped)
		match food_type:
			FoodData.FoodType.SWEET_ROLL:
				$SweetRoll.display_icing(percent_piped)
			FoodData.FoodType.PUFF_ROLL:
				$PuffRoll.display_filling(percent_piped)
		
		
		if amount_piped > 0:
			recent_drag_distances.append(amount_piped)
			if recent_drag_distances.size() >= drag_distance_average_amount:
				var average_drag_dist : float = calc_average_drag_distance()
				$SpeedDial.display_speed(average_drag_dist,target_piping_speed,target_tolerance)
				if absf(average_drag_dist-target_piping_speed) < target_tolerance:
					num_in_target += 1
				else:
					num_out_of_target += 1
				
				prints(num_in_target,",",num_out_of_target)
				recent_drag_distances.remove_at(0)
	
	if is_equal_approx(percent_piped,100.0):
		var total_data_points : float = num_in_target+num_out_of_target
		var end_score : float = num_in_target/total_data_points
		finished.emit(end_score)
		print("game over")
		

func calc_average_drag_distance() -> float:
	var sum : float
	for i in recent_drag_distances:
		sum += i
	return sum/recent_drag_distances.size()
#var slowPoints:float
#var rightPoints: float
#var fastPoints: float
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if mouse_over and Input.is_action_just_pressed("minigame_interact"):
		#pipping = true
		#slowPoints = 0
		#rightPoints = 0
		#fastPoints = 0
	#if Input.is_action_just_released("minigame_interact"):
		#pipping = false
		#RemoteTransform2D
	#if pipping and !game_done:
		#var speed :float = Input.get_last_mouse_velocity().y
		#if speed < 10:
			#speed_text.text = "NOT MOVING"
		#elif speed < slow_threshold:
			#speed_text.text = "SLOW"
			#slowPoints += 1
		#elif speed < mid_threshold:
			#speed_text.text = "JUST RIGHT"
			#rightPoints += 1
		#elif speed < fast_threshold:
			#speed_text.text = "FAST"
			#fastPoints += 1
		#slider.value = speed
	#pass
#
#
#func _on_character_body_2d_mouse_entered() -> void:
	#print("Mouse over")
	#mouse_over = true
	#pass # Replace with function body.
#
#
#func _on_character_body_2d_mouse_exited() -> void:
	#mouse_over = false
	#pass # Replace with function body.
#
#func _on_end_point_mouse_entered() -> void:
	#print("END")
	#var totalPoints: float = slowPoints + rightPoints + fastPoints
	#print("Slow: " + str(slowPoints))
	#print("RIGHT: " + str(rightPoints))
	#print("Fast: " + str(fastPoints))
	#var right_ratio : int = (rightPoints/totalPoints) * 100
	#print("RIGHT RATIO: " + str(right_ratio))
	#accuracy_text.text = "Accuracy: " + str(right_ratio) + "%"
	#game_done = true
#
	#finished.emit((right_ratio / 100.) * 3)
