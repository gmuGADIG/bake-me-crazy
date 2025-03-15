@tool
extends PathFollow2D

func get_skin_filename(s: String) -> String:
	return "res:///free_roam/player/characters/" + s + ".tres"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed := 500.0
@export var our_area: Area2D = null
@onready var area_array: Array = []
@onready var closest_body: StaticBody2D = null
@onready var closest_distance: float = 0.0
@onready var talking: bool = false
## The skin the player will be using.
## The skins live in the folder [b]characters[/b] next to this script. [br]
## In editor, the skin will automatically change, so if it doesn't change, 
## that's an indicator you misspelled a name
@export var skin := "player_1":
	set(v):
		skin = v
		if FileAccess.file_exists(get_skin_filename(v)):
			sprite.sprite_frames = load(get_skin_filename(v))

func _ready() -> void:
	sprite.sprite_frames = load(get_skin_filename(skin))

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if !talking:
		var input := Input.get_axis("move_left", "move_right")
	
		progress += input * speed * delta

		if input != 0 and not (progress_ratio in [0., 1.]):
			sprite.play("walking")
			sprite.flip_h = input < 0
		else:
			sprite.play("idle")
	monitor_interact()
		
func monitor_interact()->void:
	closest_body = null
	
	if(Input.is_action_just_pressed("interact") && !talking):
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
	if Dialogic.current_timeline == null:
		talking = false
	else:
		talking = true
	
##This takes two nodes, the player and another node, and if the other node is closer to the player than
#the closest static body, sets the "other_node" to be the new closest body!
func overlapp_process(player_node: Node2D, other_node: Node2D)->void:
	var player_pos = player_node.position
	var next_pos = other_node.position
	var distance = player_pos.distance_to(next_pos)
	
	if(distance < closest_distance):
		closest_distance = distance
		closest_body = other_node
	
