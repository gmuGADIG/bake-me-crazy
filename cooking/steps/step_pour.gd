extends FoodStep

## Target amount of flour to be poured into the bowl
@export_custom(PROPERTY_HINT_NONE, "suffix:units") var target_amount: float = 300

## How fast the player will pour in stuff
@export_custom(PROPERTY_HINT_NONE, "suffix:units/s") var pour_speed: float = 200

var flour_in_bowl: float = 0
var done := false

@onready var bowl_area: Area2D = %BowlArea
@onready var flour_pourer: DraggableObject = %PouringTool
@onready var progress_bar := $FullBar
var started := false

func _process(delta: float) -> void:
	if done: return
	if not started and flour_pourer.selected:
		started = true
		return
		
	var in_bowl_area = bowl_area.overlaps_body(flour_pourer)
	
	
	if in_bowl_area:
		flour_in_bowl = flour_in_bowl + delta * pour_speed
		progress_bar.value = flour_in_bowl
	
	if started and not flour_pourer.selected:
		var score := remap(flour_in_bowl, target_amount + pour_speed * .5, target_amount + pour_speed * 1.5, 3, 0)
		score = clampf(score, 0, 3)
		finished.emit(score)
		done = true

		print("[pour_flour] score = ", score)
