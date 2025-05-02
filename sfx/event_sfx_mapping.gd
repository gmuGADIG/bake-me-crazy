# Save this as event_sfx_mapping.gd
@tool
extends Resource
class_name EventSFXMapping

@export var node_type: String = "Button"
@export var node_group: String = ""
@export var node_name: String = ""
@export var event_name: String = "mouse_entered"
@export var sfx_id: String = "hover_sfx"
@export var stop_sfx: bool = false
