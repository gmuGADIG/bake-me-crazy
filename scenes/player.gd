extends CharacterBody2D

@export var speed := 500

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	velocity.x = Input.get_axis("ui_left", "ui_right") * speed
	move_and_slide()
