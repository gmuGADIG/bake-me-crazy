extends Sprite2D

func _ready() -> void:
	rotation = randf() * TAU

func _process(delta: float) -> void:
	rotation += delta * TAU / 15
