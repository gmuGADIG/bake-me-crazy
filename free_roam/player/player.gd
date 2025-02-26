extends PathFollow2D

@export var speed := 500.0

func _process(delta: float) -> void:
	progress += Input.get_axis("move_left", "move_right") * speed * delta
	
