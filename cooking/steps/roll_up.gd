extends FoodStep

@export var sprites: Array[Texture2D]
@export var expectedSpeed = 500
@export var speedTolerance = 200
@export var progressTotal = 10000
var curProgress = 0
var curStep = 0
@onready var FoodSprite = $Food
@onready var testLabel = $Label
@onready var runningAverage = $Label2
var isHolding = false
var lastPos = Vector2(0,0)
var sum = 0
var num = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if len(sprites) == 0: 
		print("No sprites set in RollUp step")
		return
	FoodSprite.texture = sprites[curStep]

func progressRoll() -> void:
	if curStep < len(sprites)-1:
		curStep+=1
		FoodSprite.texture = sprites[curStep]
func _input(event: InputEvent) -> void:
	test_input(event)
	#if holding and speed is in range, add to progress. 
	#next image if progress reaches total. 
	
	
func test_input(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		testLabel.text = str(event.velocity) + "\n" + testLabel.text
		sum += event.velocity.y
		num += 1
		runningAverage.text = str(sum / num)
	if event is InputEventMouseButton:
		if event.is_released():
			progressRoll()
		sum = 0
		num = 0
		runningAverage.text = "0"
	
