class_name HeartUI extends Control

var fill := 0.0:
	set(value):
		fill = value
		_update_fill()

@onready var heart_empty: TextureRect = %HeartEmpty
@onready var heart_full: TextureRect = %HeartFull
@onready var heart_mat: ShaderMaterial = heart_full.material

func _ready() -> void:
	_update_fill()

func _update_fill() -> void:
	heart_mat.set_shader_parameter("fill", fill)
	heart_full.modulate = Color.WHITE if (fill == 1.0) else Color.GRAY
	heart_empty.modulate = Color.WHITE if (fill > 0.0) else Color.DIM_GRAY
	
func set_fill_instant(value: float) -> void:
	fill = value

func set_fill_gradual(value: float) -> void:
	var time = value - self.fill
	var t = create_tween()
	t.tween_property(self, "fill", value, time)
	await t.finished
