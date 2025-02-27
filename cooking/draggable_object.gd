extends CharacterBody2D

var selectable: bool = false
var selected: bool = false
var offset: Vector2

#hold Manager is needed so you can't drag multiple objects at once
var holdManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	holdManager = $"../HoldingManager"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#check to see if mouse is hovering, clicked on and not holding something else
	if(selectable && Input.is_action_just_pressed("interact") && !holdManager._get_holding()):
		selected = true
		holdManager._set_holding(true)
		var mousePos:= get_viewport().get_mouse_position()
		offset = mousePos - position 
		print("I've been selected")
	if(Input.is_action_just_released("interact")):
		holdManager._set_holding(false)
		selected = false
		print("I've been released")
		
	#holds object at an offset so doesn't jump when clicked on
	if(selected):
		position = get_viewport().get_mouse_position() - offset

	move_and_slide()
	pass

#Check if mouse is over object
func _on_mouse_entered() -> void:
	#Turn on hover outline/anim
	selectable = true
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	#turn off hover outline/anim
	selectable = false
	pass # Replace with function body.
