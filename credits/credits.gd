extends Control

signal scrolling_started

@export var start_pause := 1.5

@onready var background: ScrollingBackground = %Background
@onready var scroller: Scroller = %Scroller

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(start_pause, false).timeout
	background.started = true
	scroller.started = true

	scrolling_started.emit()
