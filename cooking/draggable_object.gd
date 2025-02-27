extends CharacterBody2D
var selectable: bool = false
var selected: bool = false
var offset: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(selectable && Input.is_action_just_pressed("interact")):
		selected = true
		var mousePos:= get_viewport().get_mouse_position()
		offset = mousePos - position
		print("I've been selected")
	if(Input.is_action_just_released("interact")):
		selected = false
		print("I've been released")
		
	if(selected):
		position = get_viewport().get_mouse_position() - offset

	move_and_slide()
	pass


func _on_mouse_entered() -> void:
	selectable = true
	print("mouse over")
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	selectable = false
	print("Mouse off")
	pass # Replace with function body.
