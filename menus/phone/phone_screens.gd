extends Control
class_name PhoneScreen

## Class to manage which screens are open
## When a button is clicked a signal will be passed

@onready var screen_home = %Screen
@onready var screen_messages = %Messages
@onready var screen_gallery = %Gallery
@onready var screen_inventory = %Inventory
@onready var back_button = %BackButton

var current_menu = null

func _ready() -> void:
	back_button.visible = false
	current_menu = screen_home #the current menu that is already open is the home screen of the phone
	current_menu.visible = true
	screen_messages.visible = false
	screen_gallery.visible = false
	screen_inventory.visible = false

func _on_visibility_changed() -> void:
	show_menu(screen_home)

func open_screen() -> void:
	back_button.visible = false

func show_menu(menu, show_back_button := true): #parameter is the unique variable name of the panel screens on the phone
	current_menu.visible = false #whatever screen is currently "open", it will "close" that
	menu.visible = true # "Opens" the desired menu
	current_menu = menu # makes the "open" menu the new current menu screen open
	
	back_button.visible = show_back_button

func open_contacts() -> void:
	show_menu(screen_messages)

func open_gallery() -> void:
	show_menu(screen_gallery)

func open_inventory() -> void:
	show_menu(screen_inventory)

func open_recipe_book() -> void:
	Phone.instance.close_phone()
	RecipeBookOpener.instance.open_book()

func _on_back_pressed() -> void:
	show_menu(screen_home, false)
