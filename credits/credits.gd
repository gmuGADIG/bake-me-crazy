class_name Credits
extends Control

signal scrolling_started

@export var start_pause := 1.5

@onready var background: ScrollingBackground = %Background
@onready var scroller: Scroller = %Scroller
@onready var anim: AnimationPlayer = %Animator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(start_pause, false).timeout
	background.started = true
	scroller.started = true
	anim.play("darken_and_blur")

	scrolling_started.emit()
