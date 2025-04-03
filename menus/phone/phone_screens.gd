extends Control
class_name PhoneScreen

## Class to manage which screens are open
## When a button is clicked a signal will be passed

@onready var HomeScreen = %Screen
@onready var TestScreen = %Panel

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func close_screen() -> void:
	pass
	
func open_screen() -> void:
	pass


func _on_app_pressed(button_id: int) -> void:
	print(button_id)
	match button_id:
		0:
			print("button 0")
			HomeScreen.visible = false
			TestScreen.visible = true
			
		1:
			pass
	pass # Replace with function body.
