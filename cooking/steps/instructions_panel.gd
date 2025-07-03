@tool
extends Node
class_name InstructionsPanel

# TODO: Decide whether we use this or not.
# - The pour_floor minigame always needs to show the recipe so that we can
#   see how many grams to pour.
# - We could also add a dismiss button.
# - 
# static var seen: Dictionary = {}

@onready var recipe   : RichTextLabel = %RECIPE
@onready var title_box: RichTextLabel = %TaskTitle
@onready var text_box : RichTextLabel = %Instructions
@onready var step_num : Label         = %TaskNumber

@export var minigame_title:String: set = set_title
@export_multiline var instructions:String: set = set_instruct

func close_book() -> void:
	$AnimationPlayer.play("close_book")

func parent_name() -> String:
	return get_parent().name
	
func update_step_num() -> void:
	if MorningShift.instance:
		step_num.text = str(MorningShift.instance.current_step, ".")
	else:
		step_num.text = "-"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# if parent_name() in seen and not Engine.is_editor_hint():
	# 	queue_free()
	
	# seen[parent_name()] = null
	var display_name = "RECIPE"
	if MorningShift.instance:
		if MorningShift.instance.current_recipe:
			display_name = MorningShift.instance.current_recipe.display_name
	update_step_num()

	recipe.text = str("[center]", display_name, "[/center]")
	title_box.text = minigame_title
	text_box.text = instructions
	
	pass # Replace with function body.
	
func set_instruct(new_value: String) ->void:
	instructions = new_value
	if text_box != null:
		text_box.text = instructions
	
func set_title(new_value: String) -> void:
	minigame_title = new_value
	if title_box != null:
		title_box.text = str("[wave freq=5]", minigame_title, "[/wave]")
