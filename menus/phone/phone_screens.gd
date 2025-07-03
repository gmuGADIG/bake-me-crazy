extends Control
class_name PhoneScreen

## Class to manage which screens are open
## When a button is clicked a signal will be passed

@onready var HomeScreen = %Screen
@onready var TestScreen = %Contacts
@onready var TestScreen2 = %Messages
@onready var TestScreen3 = %Gallery
@onready var TestScreen4 = %Inventory
@onready var BackButton = %BackButton

var current_menu = null

func _ready() -> void:
	BackButton.visible = false
	current_menu = HomeScreen #the current menu that is already open is the home screen of the phone
	current_menu.visible = true
	TestScreen.visible = false
	TestScreen2.visible = false
	TestScreen3.visible = false
	TestScreen4.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func close_screen() -> void:
	pass
	
func open_screen() -> void:
	BackButton.visible = false
	pass

func show_menu(menu): #parameter is the unique variable name of the panel screens on the phone
	current_menu.visible = false #whatever screen is currently "open", it will "close" that
	menu.visible = true # "Opens" the desired menu
	current_menu = menu # makes the "open" menu the new current menu screen open

# The 4 apps will be Contacts, Messages, Gallery, and Inventory
func _on_app_pressed(button_idx: int) -> void:	
	var menus = [TestScreen, TestScreen2, TestScreen3, TestScreen4]
	show_menu(menus[button_idx])
	BackButton.visible = true
	
func _on_back_pressed() -> void:
	print("take it back now yall")
	show_menu(HomeScreen)
	BackButton.visible = false
	pass
