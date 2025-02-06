extends CharacterBody2D

@export var speed := 500.0

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	print("Hello World!")

func _process(delta: float) -> void:
	velocity.x = Input.get_axis("ui_left", "ui_right") * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		var overlaps := area_2d.get_overlapping_bodies()
		for overlap in overlaps:
			var frog := preload("res://flower_frog.tscn").instantiate()
			add_sibling(frog)
			frog.position = overlap.position

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hello!")

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("goodbye!")
