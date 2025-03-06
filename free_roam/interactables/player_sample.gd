extends CharacterBody2D

##NOTE: THIS IS JUST A PLACEHOLDER! This is intended to test the interactions with objects, feel free
##to delete the process and physics process functions when merging this into the actual player script.
##Don't forget the variables!

@export var speed = 500
@export var our_area: Area2D = null
@onready var area_array: Array = []
@onready var closest_body: StaticBody2D = null
@onready var closest_distance: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	monitor_interact()
	
#Delete when merging into the player.gd script!
func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down") 
	velocity = input_direction * speed;
	move_and_slide()
	
##Checks if the player is pressing down on the interact button, if so, call the interactables' interact
##function on any overlapping static bodies!
func monitor_interact()->void:
	closest_body = null
	if(Input.is_action_just_pressed("interact")):
		var body_array = our_area.get_overlapping_bodies() 
		
		#Finds the closest static body (interactable) that the player is near!
		for this_body in body_array:
			if(this_body is Interactable):
				if(closest_body == null):
					closest_body = this_body
					closest_distance = 10000000
				else:
					overlapp_process(get_node("."), this_body)
		if(closest_body != null):				
			if(closest_body is Interactable):
				closest_body._interact()
	
##This takes two nodes, the player and another node, and if the other node is closer to the player than
#the closest static body, sets the "other_node" to be the new closest body!
func overlapp_process(player_node: Node2D, other_node: Node2D)->void:
	var player_pos = player_node.position
	var next_pos = other_node.position
	var distance = player_pos.distance_to(next_pos)
	
	if(distance < closest_distance):
		closest_distance = distance
		closest_body = other_node
