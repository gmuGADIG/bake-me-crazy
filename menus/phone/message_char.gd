extends Control

@export var npc_code_name: String
@export var npc_display_name: String
@export var color: Color
@export var icon: Texture2D

func _ready() -> void:
	%FaceIcon.texture = icon
	%Panel.modulate = color
	%Name.text = npc_display_name
	%HeartsDisplay.npc = npc_code_name
