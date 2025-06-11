extends Control
@onready var master_slider:= %MasterVolSlider
@onready var music_slider := %MusicVolSlider
@onready var sfx_slider := %SFXVolSlider

var master_bus := AudioServer.get_bus_index("Master")
var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

const BOTTOM_Y = 660
var open_close_tween: Tween = null

# for animating the panel scale
var scale_theta: float = 0.0
@onready var center_panel := %CenterPanel

func animate_open_close(open: bool):
	if open_close_tween:
		open_close_tween.kill()
	open_close_tween = create_tween()
	self.position.y = BOTTOM_Y if open else 0
	open_close_tween.tween_property(self, "position:y", 0 if open else BOTTOM_Y, 0.3)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	if not open:
		open_close_tween.tween_callback(queue_free)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Get current vol settings on load and set them (I just made place holders to test)
	master_slider.value = 1
	music_slider.value = 1
	sfx_slider.value = 1
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_slider.value))
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_slider.value))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_slider.value))
	
	animate_open_close(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale_theta += TAU * delta * 0.7
	scale_theta = fmod(scale_theta, TAU)
	center_panel.scale.y = 1 + 0.01 * sin(scale_theta)
	center_panel.scale.x = 1 - 0.01 * cos(scale_theta)


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
	animate_open_close(false)
	
