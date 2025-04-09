extends Sprite2D

@onready var flash := $Flash

@export var flash_direction: float = 0
@export var duration: float = 1
var timer: float= 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash = $Flash
	flash.rotation_degrees = flash_direction
	(flash.texture as GradientTexture2D).width = texture.get_width() * scale.x if texture else 0
	(flash.texture as GradientTexture2D).height = texture.get_height() * scale.y if texture else 0

func adj_width():
	return texture.get_width() * scale.x

func adj_height():
	return texture.get_height() * scale.y

func diag():
	return sqrt(adj_height() ** 2 + adj_width() ** 2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir = Vector2.RIGHT.rotated(flash_direction)
	flash.position = lerp(-2 * dir * diag(), dir * diag(), timer/duration)
	timer += delta
	while timer > duration:
		timer -= duration
	
	
	
