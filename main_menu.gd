extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
