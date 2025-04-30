extends AnimatedSprite2D

#@export var character_frames: Array[SpriteFrames]

@onready var _last_frame_position = global_position

#func _ready() -> void:
	#sprite_frames = character_frames[PlayerData.data.selected_character]

func _process(delta: float) -> void:
	var movement = global_position - _last_frame_position
	if movement.x == 0: play("idle")
	else:
		play("walking")
		flip_h = movement.x > 0 # this assumes the default orientation is facing left
	
	_last_frame_position = global_position
