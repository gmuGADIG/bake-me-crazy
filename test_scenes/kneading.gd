extends Node2D

@export var maxStretch: float = 200
@export var stretchPerFrame : float = 0.05
@export var positionOffset: float = 0.1
@export var spriteRect: NinePatchRect

var mouseOver: bool = false
var kneading: bool = false
var centerY: float

var kneadPoints: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var startPos: Vector2 = get_global_transform().get_origin()
	var size : float = get_canvas_transform().get_scale().y
	print(size)
	centerY = startPos.y
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
	if kneading:
		
		var stretch : float = lastPosY- get_global_mouse_position().y
		if(stretch > 0 and get_global_mouse_position().y != lastPosY):
			if(abs(stretch) <= maxStretch):
				spriteRect.scale.y += stretchPerFrame
				spriteRect.position.y -= positionOffset
		elif(stretch < 0 and get_global_mouse_position().y != lastPosY):
			if(abs(stretch) <= maxStretch):
				spriteRect.scale.y += stretchPerFrame
				spriteRect.position.y += stretchPerFrame

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
