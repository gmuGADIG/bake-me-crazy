class_name LunchRushNPC extends Sprite2D

@export var sprite_options: Array[Texture]

@onready var anim: AnimationPlayer = $AnimationPlayer

static var npc_history: Array[int]

func _ready() -> void:
	# pick npc
	texture = sprite_options[pick_npc()]
	
	# enter animation
	anim.play("enter")
	await anim.animation_finished
	anim.play("idle")

func pick_npc() -> int:
	var idx = randi_range(0, sprite_options.size()-1)
	if idx in npc_history:
		return pick_npc()
	else:
		npc_history.append(idx)
		if npc_history.size() > 5: npc_history.pop_front()
		return idx

func exit() -> void:
	anim.play("exit")
	await anim.animation_finished
	queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		_ready()
