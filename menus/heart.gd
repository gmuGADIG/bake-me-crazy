extends Sprite2D

@export var delay := 0.

func _ready() -> void:
	await get_tree().create_timer(delay).timeout
	
	var tween := create_tween()
	tween.tween_interval(.7)
	tween.tween_property(self, "scale", scale * .8, 0.1)
	tween.tween_property(self, "scale", scale, 0.2)
	tween.set_loops()
