class_name DraggableObject extends CharacterBody2D

var selectable: bool = false
var selected: bool = false
var offset: Vector2

#hold Manager is needed so you can't drag multiple objects at once
@onready var holding_manager: HoldingManager = $"../HoldingManager"

func _process(_delta: float) -> void:
	#check to see if mouse is hovering, clicked on and not holding something else
	if selectable and Input.is_action_just_pressed("interact") and not holding_manager.holding:
		selected = true
		holding_manager.holding = true
		var mouse_pos := get_viewport().get_mouse_position()
		offset = mouse_pos - position 
		print("[draggable_object] I've been selected")
	if Input.is_action_just_released("interact"):
		holding_manager.holding = false
		selected = false
		print("[draggable_object] I've been released")
		
	#holds object at an offset so doesn't jump when clicked on
	if selected:
		position = get_viewport().get_mouse_position() - offset

	move_and_slide()

#Check if mouse is over object
func _on_mouse_entered() -> void:
	#Turn on hover outline/anim
	selectable = true

func _on_mouse_exited() -> void:
	#turn off hover outline/anim
	selectable = false
