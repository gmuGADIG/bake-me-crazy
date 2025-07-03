extends RigidBody2D
class_name PourParticle

var _lifetime := 2.0

var target_scale := randf_range(0.25, 1.5)
var current_scale := 0.0

@onready var sprite := %Sprite2D
@onready var collision := %CollisionShape2D

@onready var sprite_init_scale: float = %Sprite2D.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_scale = move_toward(current_scale, target_scale, delta * 4.0)
	sprite.scale.x = current_scale * sprite_init_scale
	sprite.scale.y = sprite.scale.x
	collision.scale = sprite.scale
	
	_lifetime -= delta
	if _lifetime < 0:
		queue_free()
