@tool
extends PathFollow2D

func get_skin_filename(s: String) -> String:
	return "res:///free_roam/player/characters/" + s + ".tres"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed := 500.0

## The skin the player will be using.
## The skins live in the folder [b]characters[/b] next to this script. [br]
## In editor, the skin will automatically change, so if it doesn't change, 
## that's an indicator you misspelled a name
@export var skin := "player_1":
	set(v):
		skin = v
		#The following breaks if you change the skin in the inspector.I don't know why its here
		#if FileAccess.file_exists(get_skin_filename(v)):
			#sprite.sprite_frames = load(get_skin_filename(v))

func _ready() -> void:
	sprite.sprite_frames = load(get_skin_filename(skin))

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	var input := Input.get_axis("move_left", "move_right")
	progress += input * speed * delta

	if input != 0 and not (progress_ratio in [0., 1.]):
		sprite.play("walking")
		sprite.flip_h = input < 0
	else:
		sprite.play("idle")
	
func _set_sprite(skin_name: String) -> void:
	print("Should change skin")
	sprite.sprite_frames = load(get_skin_filename(skin_name))
	pass
