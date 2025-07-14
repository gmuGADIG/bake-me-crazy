extends FoodStep

@onready var full_puff_roll_sprite : Sprite2D = $PuffRoll/Sprites/PastryFull

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	##This code is a little cursed, but I couldn't find a variable other than the display name for detecting the variant
	var recipe : FoodData = MorningShift.instance.current_recipe if MorningShift.instance != null else null
	##Define the type here if you don't want to keep walking through the street during debug (for testing)
	if recipe == null:
		recipe = load("res://items/foods/sweet_roll_orange.tres")
	
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
	if recipe.food_type == FoodData.FoodType.SWEET_ROLL:
		if recipe.ingredient == null:##normal sweet rolls
			pass
		elif recipe.ingredient.ingredient_type == IngredientData.IngredientType.CINNAMON:
			$SweetRoll/Sprites/GlazedRoll.texture = preload("res://items/foods/art/CinnamonRoll.png")
		elif recipe.ingredient.ingredient_type == IngredientData.IngredientType.ORANGE:
			$SweetRoll/Sprites/GlazedRoll.texture = preload("res://items/foods/art/OrangeSweetRoll.png")
		elif recipe.ingredient.ingredient_type == IngredientData.IngredientType.PISTACHIO:
			$SweetRoll/Sprites/GlazedRoll.texture = preload("res://items/foods/art/PistachioSweetRoll.png")
		else:
			assert(false,"There are no sprites for this given variant")
	elif recipe.food_type == FoodData.FoodType.PUFF_ROLL:
		
		
		assert(recipe.ingredient != null, "All puff rolls should have a filling >:(")
		if recipe.ingredient.ingredient_type == IngredientData.IngredientType.PORK:
			full_puff_roll_sprite.texture = preload("res://items/foods/art/PuffRoll_Sausage.png")
		elif recipe.ingredient.ingredient_type == IngredientData.IngredientType.CHEESE:
			full_puff_roll_sprite.texture = preload("res://items/foods/art/PuffRoll_Spinach.png")
		elif recipe.ingredient.ingredient_type == IngredientData.IngredientType.PISTACHIO:
			full_puff_roll_sprite.texture = preload("res://items/foods/art/PuffRoll_Baclava.png")
		else:
			assert(false,"There are no sprites for this given variant")
	else:
		assert(false,"There are no sprites for this given food type")
			
#
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
