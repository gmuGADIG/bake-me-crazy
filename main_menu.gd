extends Control

var time_passed := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	for i in range($VBoxContainer.get_child_count()):
		var button = $VBoxContainer.get_child(i)
		var pivot = $VBoxContainer.get_child(i).get_pivot_offset()
		if button is Button:
			pivot = size / 2
			var offset = i * 0.5  # Slight phase shift for each button
			button.rotation_degrees = sin(time_passed * 5 + offset) * 5  # Wiggle effect
	pass


func _on_start_game_pressed() -> void:
	print("Game started") # Temporary code


func _on_load_game_pressed() -> void:
	print("Loaded game") # Temporary code


func _on_options_pressed() -> void:
	print("Options screen transition") # Temporary Code


func _on_credits_pressed() -> void:
	print("GADIG made this game") # Temporary code


func _on_quit_game_pressed() -> void:
	get_tree().quit()
