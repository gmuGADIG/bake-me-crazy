extends Node2D

@export var maxStretch: float = 200
@export var stretchPerFrame : float = 0.05
@export var positionOffset: float = 0.1
@export var fastPointGain: int = 3
@export var midPointGain: int = 2
@export var slowPointGain: int = 1
var pointGain:int

@export var maxPoints: = 1000

@onready var spriteRect: NinePatchRect = $CanvasLayer/NinePatchRect
@onready var meter: VSlider =$CanvasLayer/VSlider
@onready var finalScoreText = $CanvasLayer/Label

var mouseOver: bool = false
var canKnead: bool = true;
var kneading: bool = false
var centerY: float

var kneadPoints: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	meter.max_value = maxPoints
	pointGain = fastPointGain
	finalScoreText.visible = false
	var size : float = get_canvas_transform().get_scale().y
	print(size)
	
	pass # Replace with function body.

var lastStretch: float = 0
var lastPosY: float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouseOver and Input.is_action_just_pressed("interact"):
		lastPosY = get_global_mouse_position().y
		kneading = true
		lastStretch = 0
	if Input.is_action_just_released("interact"):
		kneading = false
		canKnead = false
		finalScoreText.visible = true
		finalScoreText.text = "FINAL VALUE " + str(meter.value/10)
		
		
	if kneading and canKnead:
		var stretch : float = lastPosY- get_global_mouse_position().y
		if(stretch > 0 and get_global_mouse_position().y != lastPosY):
			if(abs(stretch) <= maxStretch):
				spriteRect.size.y += stretchPerFrame * delta
				spriteRect.position.y -= positionOffset
				meter.value += pointGain
		elif(stretch < 0 and get_global_mouse_position().y != lastPosY):
			if(abs(stretch) <= maxStretch):
				spriteRect.size.y += stretchPerFrame * delta
				spriteRect.position.y += positionOffset
				meter.value += pointGain
				
		
		if(meter.value > 400):
			pointGain = slowPointGain
		elif meter.value > 250:
			pointGain = midPointGain
		lastPosY = get_global_mouse_position().y	
			
	pass


func _on_area_2d_mouse_entered() -> void:
	print("mouse over")
	mouseOver = true
	
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	print("Mouse off")
	print(spriteRect.scale.y)
	mouseOver = false
	pass # Replace with function body.
