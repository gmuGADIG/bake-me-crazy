extends FoodStep

var mixes : Array[Area2D] = [$FirstMix, $SecondMix, $ThirdMix, $FourthMix]

# Called when the node enters the scene tree for the first time.
var mouse : bool = false
var count_mixes = 0
@onready var doneness: Sprite2D = $GoodnessPointer

func _ready() -> void:
	connect("input_event", Callable(self, "_on_Area2D_input_event"))
	connect("mouse_entered", Callable(self, "_on_area_2d_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_area_2d_mouse_exited"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	var prev_checkpoint = 0
	var checkpoint = 0
	var mix_checkpoint = mixes[0]
	var result = 0
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouse and (prev_checkpoint == checkpoint):
			count_mixes += 1
			mix_checkpoint = mixes[checkpoint]
			prev_checkpoint = checkpoint
			checkpoint += 1
			mouse = false
			if doneness.position.y > 0:
				doneness.position.y -= 5
			print("Left mouse button clicked inside Area2D!")
		elif !mouse:
			prev_checkpoint += 1
	else:
		if count_mixes != 0:
			result = assess_score(count_mixes)
			emit_signal("finished", result)
	print(count_mixes)

func assess_score(count_mixes) -> int:
	if count_mixes > 50:
		count_mixes = 100 - count_mixes
	print(count_mixes * 2)
	return count_mixes * 2


func _on_area_2d_mouse_entered() -> bool:
	mouse = true
	print("Mouse is now over the area!")
	return true

func _on_area_2d_mouse_exited() -> bool:
	mouse = false
	print("Mouse just left the area.")
	return false
