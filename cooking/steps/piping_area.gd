extends Node2D

signal pipping_done

var mouse_over:bool = false
var pipping: bool = false
@export var pipping_sprite: Texture
@export var sprite_node: Sprite2D
@export var pipping_speed: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("this is working")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_over and Input.is_action_just_pressed("interact"):
		pipping = true
		sprite_node.scale = Vector2(0.1, 0.1)
		sprite_node.texture = pipping_sprite
		print("poke")
	if pipping == true:
		sprite_node.scale += Vector2(pipping_speed, pipping_speed) * delta
	if mouse_over and Input.is_action_just_released("interact"):
		pipping = false
		pipping_done.emit()
		set_process(false)
		
	pass

func _on_piping_area_mouse_entered() -> void:
	mouse_over = true
	pass # Replace with function body.


func _on_piping_area_mouse_exited() -> void:
	mouse_over = false
	pass # Replace with function body.
