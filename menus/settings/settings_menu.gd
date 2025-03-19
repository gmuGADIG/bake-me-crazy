extends Control
@onready var master_slider:= $VBoxContainer/MasterVolSlider
@onready var music_slider := $VBoxContainer/MusicVolSlider
@onready var sfx_slider := $VBoxContainer/SFXVolSlider

var master_bus := AudioServer.get_bus_index("Master")
var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Get current vol settings on load and set them (I just made place holders to test)
	master_slider.value = 1
	music_slider.value = 1
	sfx_slider.value = 1
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_slider.value))
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_slider.value))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_slider.value))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_master_vol_slider_value_changed(value: float) -> void:
	print("Master Volume is ", value)
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))


func _on_music_vol_slider_value_changed(value: float) -> void:
	print("Music Volume is ", value)
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_slider.value))


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	print("SFX Volume is ", value)
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_slider.value))


func _on_back_button_pressed() -> void:
	queue_free()
	
