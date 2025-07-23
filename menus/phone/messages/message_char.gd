class_name MessageChar extends ButtonHover

@export var npc_code_name: String
@export var npc_display_name: String
@export var color: Color
@export var icon: Texture2D

@onready var text_nodes: Control = %TextNodes
@onready var unread_text: RichTextLabel = %UnreadText

func _ready() -> void:
	super._ready()
	
	%FaceIcon.texture = icon
	%Panel.modulate = color
	%Name.text = npc_display_name
	%HeartsDisplay.npc = npc_code_name
	
	visibility_changed.connect(update_texts)

func update_texts() -> void:
	var texts = TextManager.get_unread_texts(npc_code_name)
	if texts.size() > 0:
		disabled = false
		text_nodes.visible = true
		unread_text.text = "[right][wave]%d Unread!" % texts.size()
	else:
		disabled = true
		text_nodes.visible = false

func _on_pressed() -> void:
	# note: the button can only be pressed when there's at least one unread message
	Phone.instance.close_phone()
	TextManager.get_unread_texts(npc_code_name)[0].read()
