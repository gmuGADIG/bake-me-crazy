extends GridContainer

@onready var CScreen = %ContactScreen
@onready var Contact1 = %Contact1
@onready var Contact2 = %Contact2

@onready var FirstBack = %BackButton
@onready var BackButton = %ContactsBackButton

var current_menu = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_menu = CScreen
	BackButton.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_app_pressed() -> void:
	pass

func show_menu(menu): #parameter is the unique variable name of the panel screens on the phone
	current_menu.visible = false #whatever screen is currently "open", it will "close" that
	menu.visible = true # "Opens" the desired menu
	current_menu = menu # makes the "open" menu the new current menu screen open
# so this is one layer deep of buttons and panels.
func _on_texture_button_pressed(contact_id: int) -> void:
	
	match (contact_id):
		1:
			print(contact_id)
			show_menu(Contact1)
			FirstBack.visible = false
			BackButton.visible = true
		2:
			print(contact_id)
			show_menu(Contact2)
			FirstBack.visible = false
			BackButton.visible = true
			
	
	pass # Replace with function body.


func _on_contacts_back_button_pressed() -> void:
	print("RETREAT")
	show_menu(CScreen)
	BackButton.visible = false
	FirstBack.visible = true
	pass # Replace with function body.
