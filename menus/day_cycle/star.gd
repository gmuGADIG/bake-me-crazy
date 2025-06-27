extends Sprite2D
class_name DayCycleStar

func _ready() -> void:
	$AnimationPlayer.speed_scale = randf_range(0.9, 1.2)
