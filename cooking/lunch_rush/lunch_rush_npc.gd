class_name LunchRushNPC extends Node2D

@export var sprite_options: Array[Texture]

@onready var anim: AnimationPlayer = %AnimationPlayer

static var npc_history: Array[int]

func _ready() -> void:
	# pick npc
	%NPC.texture = sprite_options[pick_npc()]
	
	# enter animation
	await anim.animation_finished
	anim.play("idle")

func set_food(requested_food: FoodItem, requested_flavor: FoodItem) -> void:
	%FoodTexture.texture = requested_food.image
	%FlavorTexture.texture = requested_flavor.image

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
