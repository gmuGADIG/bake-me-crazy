@tool
extends DialogicLayoutLayer

## A layer that allows showing up to 10 choices.
## Choices are positioned in the center of the screen.

@export_group("Text")
@export_subgroup('Font')
@export var font_use_global: bool = true
@export_file('*.ttf', '*.tres') var font_custom: String = ""
@export_subgroup('Size')
@export var font_size_use_global: bool = true
@export var font_size_custom: int = 16
@export_subgroup('Color')
@export var text_color_use_global: bool = true
@export var text_color_custom: Color = Color.WHITE
@export var text_color_pressed: Color = Color.WHITE
@export var text_color_hovered: Color = Color.GRAY
@export var text_color_disabled: Color = Color.DARK_GRAY
@export var text_color_focused: Color = Color.WHITE

@export_group('Boxes')
@export_subgroup('Panels')
@export_file('*.tres') var boxes_stylebox_normal: String = "res://addons/dialogic/Modules/DefaultLayoutParts/Layer_VN_Choices/choice_panel_normal.tres"
@export_file('*.tres') var boxes_stylebox_hovered: String = "res://addons/dialogic/Modules/DefaultLayoutParts/Layer_VN_Choices/choice_panel_hover.tres"
@export_file('*.tres') var boxes_stylebox_pressed: String = ""
@export_file('*.tres') var boxes_stylebox_disabled: String = ""
@export_file('*.tres') var boxes_stylebox_focused: String = "res://addons/dialogic/Modules/DefaultLayoutParts/Layer_VN_Choices/choice_panel_focus.tres"
@export_subgroup('Modulate')
@export_subgroup('Size & Position')
@export var boxes_v_separation: int = 10
@export var boxes_fill_width: bool = true
@export var boxes_min_size: Vector2 = Vector2()
@export var boxes_offset: Vector2 = Vector2()

@export_group('Sounds')
@export_range(-80, 24, 0.01) var sounds_volume: float = -10
@export_file("*.wav", "*.ogg", "*.mp3") var sounds_pressed: String = "res://addons/dialogic/Example Assets/sound-effects/typing1.wav"
@export_file("*.wav", "*.ogg", "*.mp3") var sounds_hover: String = "res://addons/dialogic/Example Assets/sound-effects/typing2.wav"
@export_file("*.wav", "*.ogg", "*.mp3") var sounds_focus: String = "res://addons/dialogic/Example Assets/sound-effects/typing4.wav"

func get_choices() -> VBoxContainer:
	return $Choices


func get_button_sound() -> DialogicNode_ButtonSound:
	return %DialogicNode_ButtonSound


## Method that applies all exported settings
func _apply_export_overrides() -> void:
	return
