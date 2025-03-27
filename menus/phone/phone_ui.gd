extends Control

var phone_opened = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phone_opened = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if phone_opened:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_phone_top_pressed() -> void:
	#play phone open animation AND pause other input
	#TODO: Play animations
	if phone_opened:
		phone_opened = false
	else:
		phone_opened = true
