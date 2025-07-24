extends FoodStep

signal piping_bag_sfx
signal piping_bag_sfx_cancel

@export var percent_piped_per_pixel : float = 10

@export var target_piping_speed : float = 0.5
@export var target_tolerance : float = 0.2

var num_in_target : int
var num_out_of_target : int

var percent_piped : float = 0.0 ##Ranges between 0 and 100

var last_mouse_pos : Vector2
@export var drag_sample_size_requirement : int = 10 ##The size of rolling_drag_distance needed to calculate the average drag distance. More = larger delay when first piping 
var recent_drag_distances : Array[float]

var currently_piping : bool



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var recipe : FoodData = MorningShift.instance.current_recipe if MorningShift.instance != null else null
	##Define the type here if you don't want to keep walking through the street during debug (for testing)
	if recipe == null:
		recipe = load("res://items/foods/sweet_roll_cinnamon.tres")
	set_icing_color(recipe.ingredient.ingredient_type if recipe.ingredient != null else null)
	
	$StopSFXTimer.wait_time = 0.3
	$StopSFXTimer.timeout.connect(func():
		piping_bag_sfx_cancel.emit()
	)

func set_icing_color(ingredient : IngredientData.IngredientType) -> void:
	var icing_color : Color
	match ingredient:
		null:
			icing_color = Color.ANTIQUE_WHITE
		IngredientData.IngredientType.CINNAMON:
			icing_color = Color.SIENNA
		IngredientData.IngredientType.ORANGE:
			icing_color = Color.ORANGE
		IngredientData.IngredientType.PISTACHIO:
			icing_color = Color.WEB_GREEN
		IngredientData.IngredientType.PORK:
			icing_color = Color.SADDLE_BROWN
		IngredientData.IngredientType.CHEESE:
			icing_color = Color.LIGHT_GREEN
		
	$PipingBag/Sprites/PipingBagFull.modulate = icing_color
	$Icing/Visual.default_color = icing_color

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("minigame_interact"):
		$InstructionsPanel.hide()
		
func _physics_process(delta: float) -> void:
	if $PipingBag.is_lowered():
		if not currently_piping:
			currently_piping = true
			last_mouse_pos = get_global_mouse_position()
	else:
		currently_piping = false
	
	if currently_piping:
		var new_mouse_pos : Vector2 = get_global_mouse_position()
		var drag_dist : float = new_mouse_pos.x-last_mouse_pos.x
		var amount_piped : float = max(drag_dist*percent_piped_per_pixel*delta,0)
		percent_piped = move_toward(percent_piped,100.0,amount_piped)
		
		
		var icing_size : PipeLineIcing.IcingSize = PipeLineIcing.IcingSize.NONE
		
		
		if amount_piped > 0:
			recent_drag_distances.append(amount_piped)
			var is_sample_size_large_enough : bool = recent_drag_distances.size() >= drag_sample_size_requirement
			if is_sample_size_large_enough:
				var average_drag_dist : float = averagef(recent_drag_distances)
				
				var distance_from_target_piping_speed : float = average_drag_dist-target_piping_speed
				if distance_from_target_piping_speed > target_tolerance:
					num_out_of_target += 1
					icing_size = PipeLineIcing.IcingSize.TOO_LARGE
				elif distance_from_target_piping_speed < -target_tolerance:
					num_out_of_target += 1
					icing_size = PipeLineIcing.IcingSize.TOO_SMALL
				else:
					num_in_target += 1
					icing_size = PipeLineIcing.IcingSize.JUST_RIGHT
					
				recent_drag_distances.remove_at(0)
			piping_bag_sfx.emit()
			$StopSFXTimer.stop()
		else:
			if $StopSFXTimer.is_stopped():
				$StopSFXTimer.start()
		## Visual & Audio Feedback
		$PipingBag.display_piping_bag(percent_piped)
		if not icing_size == PipeLineIcing.IcingSize.NONE:
			$Icing.draw_icing_line(icing_size)
		last_mouse_pos = new_mouse_pos
	elif $StopSFXTimer.is_stopped():
		$StopSFXTimer.start()
	
	if is_equal_approx(percent_piped,100.0):
		piping_bag_sfx_cancel.emit()
		
		var total_data_points : float = num_in_target+num_out_of_target
		var end_score : float = 3.0*(num_in_target/total_data_points)
		finished.emit(end_score)
		print(end_score)


func averagef(array : Array[float]) -> float:
	var sum : float
	for i in array:
		sum += i
	return sum/array.size()
