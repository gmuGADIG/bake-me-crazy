extends Node

@export var _salty_messages: Array[DialogicTimeline]
@export var _savory_messages: Array[DialogicTimeline]
@export var _spicy_messages: Array[DialogicTimeline]
@export var _sweet_messages: Array[DialogicTimeline]

var _texts := {
	"salty": [],
	"savory": [],
	"spicy": [],
	"sweet": [],
}

enum MsgState {
	HIDDEN,
	UNREAD,
	READ,
}

func _init_msg(person: String, message_list: Array[DialogicTimeline]) -> void:
	for i in range(message_list.size()):
		if message_list[i] == null: continue
		var msg = TextMessage.new(i+1, message_list[i])
		_texts[person].append(msg)

func _ready() -> void:
	_init_msg("salty", _salty_messages)
	_init_msg("savory", _savory_messages)
	_init_msg("spicy", _spicy_messages)
	_init_msg("sweet", _sweet_messages)

func update_text_availability() -> void:
	for person in _texts.keys():
		var hearts = Dialogic.VAR.hearts.get(person)
		for text: TextMessage in _texts[person]:
			if text.state == MsgState.HIDDEN and hearts >= text.hearts_needed:
				text.state = MsgState.UNREAD

func get_unread_texts(person: String) -> Array[TextMessage]:
	var result: Array[TextMessage] = []
	for text: TextMessage in _texts[person]:
		if text.state == MsgState.UNREAD:
			result.append(text)
		
	return result

func total_unread_count() -> int:
	var result := 0
	for person in _texts.keys():
		var unreads = get_unread_texts(person)
		result += unreads.size()
	
	return result

class TextMessage:
	var message: DialogicTimeline
	var hearts_needed: int
	var state: MsgState = MsgState.HIDDEN

	func _init(p_hearts_needed: int, p_message: DialogicTimeline):
		hearts_needed = p_hearts_needed
		message = p_message

	func read() -> void:
		state = MsgState.READ
		Dialogic.start(message)
