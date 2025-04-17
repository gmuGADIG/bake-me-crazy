extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start(load("res://dialogue/testing/lunch_break_timeline.dtl"))
	await get_tree().create_timer(1.).timeout
	SceneTransition.change_scene("res://free_roam/world/streets/streets.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
