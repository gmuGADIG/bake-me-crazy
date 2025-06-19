extends FoodStep

## Target amount of flour to be poured into the bowl
@export_custom(PROPERTY_HINT_NONE, "suffix:units") var target_amount: float = 300

## How fast the player will pour in stuff
@export_custom(PROPERTY_HINT_NONE, "suffix:units/s") var pour_speed: float = 200

var flour_in_bowl: float = 0
var done := false

@onready var bowl_area: Area2D = %BowlArea
@onready var flour_pourer: CharacterBody2D = %FlourPourer

@onready var pointer_sprite: Sprite2D = %PointerSprite
@onready var grab_sprite: Sprite2D = %GrabSprite

@onready var particles: CPUParticles2D = %Powder
@onready var powder_location: Node2D = %PowderLocation


func _process(delta: float) -> void:
	if done: return
	
	flour_pourer.position = get_global_mouse_position()
	
	if(Input.is_mouse_button_pressed(1)):
		pointer_sprite.hide()
		grab_sprite.show()
		particles.emitting = true
	else:
		pointer_sprite.show()
		grab_sprite.hide()
		particles.emitting = false

	var in_bowl_area = bowl_area.overlaps_body(flour_pourer)
	
	$FlourScale.text = "%.1f" % flour_in_bowl
	
	if Input.is_mouse_button_pressed(1) && in_bowl_area:
		flour_in_bowl = flour_in_bowl + delta * pour_speed
	
	if flour_in_bowl >= target_amount and not Input.is_mouse_button_pressed(1):
		var score := remap(flour_in_bowl, target_amount + pour_speed * .5, target_amount + pour_speed * 1.5, 3, 0)
		score = clampf(score, 0, 3)
		finished.emit(score)
		
		# Hide the particles when finished so they don't show during the animation.
		particles.hide()
		done = true

		print("[pour_flour] score = ", score)
		
	particles.global_position = powder_location.global_position
