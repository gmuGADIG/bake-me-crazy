extends Control

var phone_opened = false
@onready var HomeScreen = %Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phone_opened = false
	$Panel/AnimationPlayer.play("open_phone")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if phone_opened:
	#	get_tree().paused = true
	#else:
	#	get_tree().paused = false
	pass


func _on_phone_top_pressed() -> void:  # when the button PhoneTop is pressed, this function should execute
	#play phone open animation AND pause other input
	#TODO: Play animations
	if phone_opened: #change to maybe "if phone_opened == false: 
		phone_opened = false
		# try HomeScreen/AnimationPlayer.play("open_phone")
		#$Panel/AnimationPlayer.play("open_phone")
	else:
		print("opened")
		phone_opened = true #else if it's already opened, you should close the phone
		#$Panel/AnimationPlayer.play("RESET")
