extends RigidBody2D
class_name PourParticle

var _lifetime := 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_lifetime -= delta
	if _lifetime < 0:
		queue_free()
