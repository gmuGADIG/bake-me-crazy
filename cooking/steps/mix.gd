extends Node

###mixing is CLOCKWISE only for now

var radius: int
var wiggle_room: int

var prev_mouse_position: Vector2
var intersection_point:Vector2
var mouse_position: Vector2

var current_area: Area2D

@onready var checkpoints = [%Checkpoint1,%Checkpoint2,%Checkpoint3,%Checkpoint4]


func _ready() -> void:
	##Maybe: Change this with bowl sprite?
	#screen_center = get_viewport().get_visible_rect().get_center()
	mouse_position = get_viewport().get_mouse_position()


func _process(delta: float) -> void:
	pass

func update_mouse_position() -> void:
	prev_mouse_position = mouse_position
	mouse_position = get_viewport().get_mouse_position()


#Change to radius instead?
func check_checkpoint() -> void:
	if(current_area):
		pass


func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		update_mouse_position()
		#TODO: check radius and checkpoint 

## entered on signal when mouse enters an area.
#TODO: check if the currarea is on track for a circular motion.
func _on_area_entered( area: int) -> void:
	pass
