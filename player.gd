extends CharacterBody2D

@export var speed := 500.0
func _ready() -> void:
	print("Hellow WOrld!")


func _process(delta: float) -> void:
	
	velocity.x = Input.get_axis("ui_left", "ui_right") *speed
	move_and_slide()
	
	
	
