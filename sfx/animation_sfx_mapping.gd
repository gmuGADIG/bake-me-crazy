@tool
extends Resource
class_name AnimationSFXMapping

# The name of the animation that should trigger the SFX
@export var animation_name: String = ""

# Optional group to filter which animation players this mapping applies to
@export var player_group: String = ""

@export var node_name: String = ""

# The ID of the sound effect to play
@export var sfx_id: String = ""

@export var stop_sfx: bool = false
