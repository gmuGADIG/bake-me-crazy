class_name DraggableObject extends CharacterBody2D

@export var return_on_release := true

var selectable: bool = false
var selected: bool = false
var offset: Vector2
var return_tween: Tween # tween used while the object is returning on release

#hold Manager is needed so you can't drag multiple objects at once
@onready var holding_manager: HoldingManager = $"../HoldingManager"

@onready var start_position := position

func _process(_delta: float) -> void:
	#check to see if mouse is hovering, clicked on and not holding something else
	if selectable and Input.is_action_just_pressed("minigame_interact") and not holding_manager.holding:
		selected = true
		holding_manager.holding = true
		var mouse_pos := get_viewport().get_mouse_position()
		offset = mouse_pos - position 
		
		if return_tween != null: return_tween.kill()
	if selected and Input.is_action_just_released("minigame_interact"):
		holding_manager.holding = false
		selected = false
		
		if return_on_release:
			return_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			return_tween.tween_property(self, "position", start_position, .5)
		
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
