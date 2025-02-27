extends CharacterBody2D

##NOTE: THIS IS JUST A PLACEHOLDER! This is intended to test the interactions with objects, feel free
##to delete the ready, process, and physics process functions when merging this into the actual player script.
##Don't forget the variables!
@export var speed = 500
@onready var entered_area: Area2D = null
@onready var area_node: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	monitor_interact()
	
#Delete when merging into the player.gd script!
func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down") 
	velocity = input_direction * speed;
	move_and_slide()

#When the area of the player is entered, changes the current area node (the node who has the interact function)
#to be the grandparent of the area it ran into. Will likely need some changes to a: manage being in multiple interact
#areas at the same time, and b: what if the area we ran into doesn't have a grandparent?
func _on_interact_area_entered(area: Area2D) -> void:
	entered_area = area;
	if(area.get_parent().get_parent() is Interactable):
		area_node = area.get_parent().get_parent()
	
##Checks if the player is pressing down on the interact button, if so, call the interactables' interact
##function!
func monitor_interact()->void:
	if(Input.is_action_just_pressed("interact_object")):
		if(area_node != null):
			area_node._interact()
	
func _on_interact_area_exited(area: Area2D) -> void:
	if (area == entered_area):
		entered_area = null
		area_node = null
