extends PathFollow2D

@export var speed := 500.0

func _process(delta: float) -> void:
	progress += Input.get_axis("ui_left", "ui_right") * speed * delta
	
