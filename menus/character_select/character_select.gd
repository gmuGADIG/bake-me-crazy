extends Control
var charsel: int
@export var activeChar: Sprite2D
#@export var selectChar: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_cat_button_up() -> void:
	#selectChar = 1
	char_save(1)
	activeChar.texture = load("res://menus/character_select/characters/BetterCat.png")


func _on_hood_button_up() -> void:
	#selectChar = 2
	char_save(2)
	activeChar.texture = load("res://menus/character_select/characters/HoodGuy.png")


func _on_ogre_button_up() -> void:
	#selectChar = 3
	char_save(3)
	activeChar.texture = load("res://menus/character_select/characters/Ogre.png")


func _on_people_button_up() -> void:
	#selectChar = 4
	char_save(4)
	activeChar.texture = load("res://menus/character_select/characters/People1.png")


func _on_people_1_button_up() -> void:
	#selectChar = 5
	char_save(5)
	activeChar.texture = load("res://menus/character_select/characters/People2.png")


func _on_skele_button_up() -> void:
	#selectChar = 6
	char_save(6)
	activeChar.texture = load("res://menus/character_select/characters/Skele.png")
	
func char_save(num:int)-> int:
	var charsels = ""
	while (num > 0):
		charsels = str(num & 1) + charsels
		num = num >> 1
	charsel = int(charsels)
	return int(charsels)
