extends Control
@onready var master_vol:= $VBoxContainer/MasterVolSlider
@onready var music_vol := $VBoxContainer/MusicVolSlider
@onready var sfx_vol := $VBoxContainer/SFXVolSlider

var master_bus := AudioServer.get_bus_channels("Master")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Get current vol settings on load and set them (I just made place holders to test)
	master_vol.value = 80
	music_vol.value = 60
	sfx_vol.value = 70
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_master_vol_slider_value_changed(value: float) -> void:
	print("Master Volume is ", value)



func _on_music_vol_slider_value_changed(value: float) -> void:
	print("Music Volume is ", value)


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	print("SFX Volume is ", value)


func _on_back_button_pressed() -> void:
	print("Exit Settings to previous screen")
	queue_free()
	pass # Replace with function body.
