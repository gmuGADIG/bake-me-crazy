class_name Phone extends Control

static var instance : Phone
var phone_opened = false

#@onready var HomeScreen = %Contacts
@onready var anim: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Phone.instance = self
	phone_opened = false
	print("gah")
	#$Panel/AnimationPlayer.play("open_phone")

func _process(delta: float) -> void:
	if phone_opened:
		if Input.is_action_just_pressed("open_phone") \
		or Input.is_action_just_pressed("pause"):
			phone_opened = false
			get_tree().paused = false
			anim.play_backwards("open_phone")
	else:
		if get_tree().paused: return # something else is already pausing the game
		
		if Input.is_action_just_pressed("open_phone"):
			phone_opened = true
			get_tree().paused = true
			anim.play("open_phone")
	
# when the button PhoneTop is pressed, this function should execute
func _on_phone_top_pressed() -> void:
	if phone_opened == false: #change to maybe "if phone_opened == false: 
		if get_tree().paused: return # don't open the phone of the game is currently paused (e.g. if the pause screen is open)
		
		phone_opened = true
		get_tree().paused = true
		
		get_node("Panel/AnimationPlayer").play("open_phone")
	else:	
		get_tree().paused = false
		phone_opened = false
		
		get_node("Panel/AnimationPlayer").play_backwards("open_phone")
