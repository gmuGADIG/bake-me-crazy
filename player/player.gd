extends CharacterBody2D

@export var speed := 500.0
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	print("Hello World!")

func _process(delta: float) -> void:

	var horizontal = Input.get_axis("ui_left", "ui_right")
	velocity.x = horizontal * speed
	
	# overall velocity is checked just in case we need vertical movement
	if (velocity.length() >= 0.1):
		sprite.play("walking")
		sprite.flip_h = horizontal < 0
	else:
		sprite.play("idle")
	
	move_and_slide()
