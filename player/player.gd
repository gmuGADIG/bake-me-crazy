extends CharacterBody2D

@export var speed := 500.0
@export var skin := "player_1"
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.sprite_frames = load("res://player/characters/" + skin + ".tres")

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
