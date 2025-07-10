extends FoodStep

##max value image can stretch in a single pull
@export var maxStretch: float = 200
##how much the image is scaled over a second when being pulled
@export var stretchPerSec : float = 0.05
##Scale these to work with maxPoints, less points closer you get to center
@export_group("Point gain parameters")
##how many notches on the slider make multiple of 10, >= 100
@export var maxPoints: = 1000
@export var fastPointGain: int = 3
@export var midPointGain: int = 2
@export var slowPointGain: int = 1
##When point gain changes to mid
@export var midThreshold: int = 3000
##when point gain changes to slow
@export var slowThreshold: int = 4000

var pointGain:int

@onready var spriteRect: NinePatchRect = %NinePatchRect
@onready var meter: VSlider = %VSlider

var mouseOver: bool = false
var canKnead: bool = true;
var kneading: bool = false
var centerY: float

var kneadPoints: float

func failure_ok() -> bool:
	var normalized := meter.value / meter.max_value # convert meter.value to [0, 1]
	return normalized > .1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spriteRect.pivot_offset = Vector2(spriteRect.size.x/2, spriteRect.size.y/2)
	meter.max_value = maxPoints
	pointGain = fastPointGain

var lastStretch: float = 0
var lastPosY: float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouseOver and Input.is_action_just_pressed("minigame_interact"):
		lastPosY = get_global_mouse_position().y
		kneading = true
		lastStretch = 0
	if Input.is_action_just_released("minigame_interact"):
		kneading = false
		if not failure_ok(): return
		canKnead = false

		# calculate score
		var normalized := meter.value / meter.max_value # convert meter.value to [0, 1]
		var dist := absf(.5 - normalized) # get distance from .5 on number line
		var score = remap(dist, 0, .5, 3, 0) # score is a function of dist according to the gdd
		
		print(score)
		finished.emit(score)
		
		
	if kneading and canKnead:
		var stretch : float = lastPosY- get_global_mouse_position().y
		if(stretch > 0 and get_global_mouse_position().y != lastPosY):
			if(abs(stretch) <= maxStretch):
				spriteRect.scale.y += stretchPerSec * delta
				meter.value += pointGain
		elif(stretch < 0 and get_global_mouse_position().y != lastPosY):
			if(abs(stretch) <= maxStretch):
				spriteRect.scale.y += stretchPerSec * delta
				meter.value += pointGain
				
		
		if(meter.value > slowThreshold):
			pointGain = slowPointGain
		elif meter.value > midThreshold:
			pointGain = midPointGain
		lastPosY = get_global_mouse_position().y	
			
	pass


func _on_area_2d_mouse_entered() -> void:
	# print("mouse over")
	mouseOver = true
	
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	# print("Mouse off")
	# print(spriteRect.scale.y)
	mouseOver = false
	pass # Replace with function body.
