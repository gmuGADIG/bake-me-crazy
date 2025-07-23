extends AnimatedSprite2D

@export var minigame: StepHeat

func _process(delta: float) -> void:
	modulate = Color.WHITE * (minigame.heat + 1.0)
