extends FoodStep

## Target amount of flour to be poured into the bowl
@export_custom(PROPERTY_HINT_NONE, "suffix:units") var target_amount: float = 300

## How fast the player will pour in stuff
@export_custom(PROPERTY_HINT_NONE, "suffix:units/s") var pour_speed: float = 200

var flour_in_bowl: float = 0
var done := false

@onready var bowl_area: Area2D = %BowlArea
@onready var flour_pourer: CharacterBody2D = %FlourPourer

@onready var hand_open = load("res://cooking/cooking_art/Minigame_HandCursorPoint.png")
@onready var hand_closed = load("res://cooking/cooking_art/Minigame_HandCursorGrab.png")

func _process(delta: float) -> void:
	if done: return
	
	flour_pourer.position = get_global_mouse_position();
	
	#var bool mouseDown = 
	
	if(Input.is_mouse_button_pressed(1)):
		$FlourPourer/HandSprite.texture = hand_closed
		$FlourPourer/HandSprite/Powder.emitting = true;
	else:
		$FlourPourer/HandSprite.texture = hand_open
		$FlourPourer/HandSprite/Powder.emitting = false;
		
	

	var in_bowl_area = bowl_area.overlaps_body(flour_pourer)
	
	$FlourScale.text = "%.1f" % flour_in_bowl
	
	if Input.is_mouse_button_pressed(1) && in_bowl_area:
		flour_in_bowl = flour_in_bowl + delta * pour_speed
	
	if flour_in_bowl >= target_amount and not Input.is_mouse_button_pressed(1):
		var score := remap(flour_in_bowl, target_amount + pour_speed * .5, target_amount + pour_speed * 1.5, 3, 0)
		score = clampf(score, 0, 3)
		finished.emit(score)
		done = true

		print("[pour_flour] score = ", score)
