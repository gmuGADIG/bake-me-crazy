@tool
extends PathFollow2D

func get_skin_filename(s: String) -> String:
	return "res:///free_roam/player/characters/" + s + ".tres"

@export var speed := 500.0
@export var our_area: Area2D = null

## The skin the player will be using.
## The skins live in the folder [b]characters[/b] next to this script. [br]
## In editor, the skin will automatically change, so if it doesn't change, 
## that's an indicator you misspelled a name
@export var skin := "player_1":
	set(v):
		skin = v
		if FileAccess.file_exists(get_skin_filename(v)):
			sprite.sprite_frames = load(get_skin_filename(v))


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: PlayerInteractionArea = %InteractionArea

func _ready() -> void:
	sprite.sprite_frames = load(get_skin_filename(skin))

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	# get input
	var input := Input.get_axis("move_left", "move_right")
	if interaction_area.mid_interaction: input = 0 # override input to zero to prevent movement while talking

	# move player along the line
	progress += input * speed * delta
	
	# animate player and flip left/right
	var is_walking = input != 0
	if progress_ratio in [0, 1]: is_walking = false # don't walk when already against the wall
	
	if is_walking:
		sprite.play("walking")
		sprite.flip_h = input < 0
	else:
		sprite.play("idle")
