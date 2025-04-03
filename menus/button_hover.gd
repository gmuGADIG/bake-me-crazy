class_name ButtonHover extends Button

@export var hover_scale := 1.1
@export var duration := 0.3

@onready var original_scale = scale

func _ready() -> void:
	mouse_entered.connect(func():
		create_tween().tween_property(self, "scale", Vector2.ONE * hover_scale * original_scale, duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	)
	
	mouse_exited.connect(func():
		create_tween().tween_property(self, "scale", Vector2.ONE * original_scale, duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	)

#func _process(delta: float) -> void:
	#if is_hovered():
		#create_tween().tween_property(self, "scale", Vector2.ONE * hover_scale, duration)
	#else:
		#create_tween().tween_property(self, "scale", Vector2.ONE, duration)
