extends Control

@onready var gameTimer: Label = $gameTimer
@onready var bowl: Area2D = $Bowl
@onready var place_pos: Area2D = $placePos

#Time limit
var timeLimit = 15
#Booleans to help w/ scooping
var isScooped = false
var mouseAtBowl = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Started!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Timer Code
	if timeLimit > 0:
		if timeLimit - delta != 0:
			timeLimit -= delta
		else:
			timeLimit = 0.001
		
		gameTimer.text = "Time left: %.2f" % timeLimit


	#Bowl Code
	#This code should detect when the bowl is clicked,
	#and scoops a new scoop of cookie dough
func _input(event: InputEvent) -> void:
	#print("Input: ", event.is_action_pressed)
	if event.is_action("interact") && mouseAtBowl == true && isScooped == false:
		isScooped = true;
		print("Scooped!")
	elif event.is_action("interact") && mouseAtBowl == false && isScooped == true:
		print("Placed scoop!")
		isScooped = false;

		
		#Spawns cookie dough
		#Art-stuff
		var doughSprite = Sprite2D.new()
		var texture = load("res://temp_art/gartic/forg.png")
		doughSprite.position = get_local_mouse_position()
		doughSprite.set_texture(texture)
		add_child(doughSprite)
		#Collision-stuff
		var doughCollision = CollisionShape2D.new()
		doughCollision.position = get_local_mouse_position()
		doughCollision.shape = CircleShape2D.new()
		doughCollision.shape.radius = 35
		add_child(doughCollision)
		
		"""
		print("placePos: ", place_pos.position)
		print("doughCollision: ", doughCollision.position)
		"""

#Signals to detect whether the mouse's position is at the bowl or not
#Used to help determine if cookie dough can be scooped
func _on_bowl_mouse_entered() -> void:
	print("Entered")
	mouseAtBowl = true

func _on_bowl_mouse_exited() -> void:
	print("Exited")
	mouseAtBowl = false
	


func _on_place_pos_body_entered(body: Node2D) -> void:
	print("true")
