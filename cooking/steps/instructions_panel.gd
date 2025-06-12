@tool
extends Node

static var seen: Dictionary = {}

@onready var title_box: Label = $Title
@onready var text_box : Label = $Title/InstructionsText

@export var minigame_title:String: set = set_title
@export var instructions:String: set = set_instruct

func parent_name() -> String:
	return get_parent().name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if parent_name() in seen and not Engine.is_editor_hint():
		queue_free()
	
	seen[parent_name()] = null

	title_box.text = minigame_title
	text_box.text = instructions
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_instruct(new_value: String) ->void:
	instructions = new_value
	if(text_box != null):
		text_box.text = instructions
	pass
	
func set_title(new_value: String) -> void:
	minigame_title = new_value
	if(title_box != null):
		title_box.text = minigame_title
	pass
