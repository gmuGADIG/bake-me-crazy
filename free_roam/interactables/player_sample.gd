extends CharacterBody2D

##NOTE: THIS IS JUST A PLACEHOLDER! This is intended to test the interactions with objects, feel free
##to delete the ready, process, and physics process functions when merging this into the actual player script.
##Don't forget the variables!

@export var speed = 500
@export var our_area: Area2D = null
@onready var area_array: Array = []

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
	
##Checks if the player is pressing down on the interact button, if so, call the interactables' interact
##function on any overlapping static bodies!
func monitor_interact()->void:
	if(Input.is_action_just_pressed("interact")):
		if(our_area.has_overlapping_bodies() != false):
			var area_array = our_area.get_overlapping_bodies() 
			for this_area in area_array:
				if(this_area is Interactable):
					this_area._interact()
