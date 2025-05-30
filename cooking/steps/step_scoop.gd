extends FoodStep

@onready var spoon_cookie: Sprite2D = %SpoonCookie
@onready var gameTimer: Label = $gameTimer
@onready var bowl: Area2D = $Bowl
@onready var place_pos: Area2D = $placePos

#Time limit
var timeLimit = 18
#Booleans to help w/ scooping
var isScooped = false
var mouseAtBowl = false
#Integer to count the number scoops done
var numScoop = 0
#Variables to determine next goal placement
var nextX
var nextY
#Integer to keep track of score
var score = 0
#Float to track the final time
var finishTime = 0
#Bool to tell if the game is finished
#primarily used to trigger finish() only once when time runs out
var isFinished = false

signal dough_spawned

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nextX = place_pos.position[0]
	nextY = place_pos.position[1]

#A finish function that returns the score
func finish() -> int:
	print("------------ FINISH! ------------")
	print("You scored: ", score, "/24")
	#Disable scooping
	bowl.get_child(0).disabled = true
	isScooped = false
	#Get the time at finish
	finishTime = timeLimit

	if not isFinished:
		finished.emit((score / 24.) * 3)
		isFinished = true

	return score

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	#Timer Code
	if timeLimit > 0:
		if timeLimit - delta != 0:
			timeLimit -= delta
		
		#If all scoops have been placed, the timer stops
		if finishTime != 0:
			gameTimer.text = "Time left: %.2f" % finishTime
		elif timeLimit < 0:
			gameTimer.text = "Time left: 0.00"
		else:
			gameTimer.text = "Time left: %.2f" % timeLimit
	
	#If the timer reaches 0, then the game ends
	elif isFinished == false:
		finish()


#Bowl Code
#This code should detect when the bowl is clicked, and scoops a new scoop of cookie dough
func _input(event: InputEvent) -> void:
	if event.is_action("minigame_interact") && mouseAtBowl == true && isScooped == false:
		isScooped = true
		spoon_cookie.show()
		spoon_cookie.rotation = randf() * TAU
		spoon_cookie.scale = Vector2.ONE * randf_range(.1, .125)
	elif event.is_action("minigame_interact") && mouseAtBowl == false && isScooped == true:
		#Re-enable the ability to scoop & increment number of scoops done
		isScooped = false
		numScoop += 1
		spoon_cookie.hide()

		
		#Spawns cookie dough
		#Art-stuff
		var doughSprite = Sprite2D.new()
		var texture = load("res://cooking/art/Snickerdoodle_Cookie_Dough.png")
		doughSprite.position = get_local_mouse_position()
		doughSprite.set_texture(texture)
		doughSprite.scale = spoon_cookie.scale
		doughSprite.rotation = spoon_cookie.rotation
		
		dough_spawned.emit()
		
		add_child(doughSprite)
		
		#Collision-stuff
		var doughCollision = CollisionShape2D.new()
		doughCollision.position = get_local_mouse_position()
		doughCollision.shape = CircleShape2D.new()
		doughCollision.shape.radius = place_pos.get_child(0).shape.radius
		add_child(doughCollision)
		#print("placePos: ", place_pos.position)
		#print("doughCollision: ", doughCollision.position)
		
		#Getting distance between scoop and goal
		var scoop_X = doughCollision.position[0]
		var scoop_Y = doughCollision.position[1]
		var goal_X = place_pos.position[0]
		var goal_Y = place_pos.position[1]
		
		#Calculating coverage from distance
		var distance = sqrt(((goal_X - scoop_X) * (goal_X - scoop_X)) + ((goal_Y - scoop_Y) * (goal_Y - scoop_Y)))
		var goal_diameter = place_pos.get_child(0).shape.radius * 2
		var coverage = (goal_diameter - distance)/goal_diameter
		#print("Distance: ", distance)
		#print("Coverage: ", coverage)
		
		#Giving score based on coverage
		if coverage >= 0.8:
			print("Scored 3!")
			score += 3
		elif coverage >= 0.65:
			print("Scored 2.")
			score += 2
		else:
			print("Scored 1...")
			score += 1
		
		#Setting up next goal
		if numScoop == 8: #If 12 scoops have been placed, then the game ends
			finish()
		else:
			if numScoop % 4 == 0: #If 6 scoops have been placed, the next goal goes to a new row
				nextX -= 148 * (numScoop - 1)
				nextY += 180
			else:
				nextX += 148
				
			place_pos.position = Vector2(nextX, nextY)

#Signals to detect whether the mouse's position is at the bowl or not
#Used to help determine if cookie dough can be scooped
func _on_bowl_mouse_entered() -> void:
	mouseAtBowl = true

func _on_bowl_mouse_exited() -> void:
	mouseAtBowl = false
