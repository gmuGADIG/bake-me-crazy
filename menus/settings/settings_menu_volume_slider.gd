extends HSlider
class_name SettingsMenuVolumeSlider

@export var slider_name    = "Master Volume"
@export var audio_bus_name = "Master"

@onready var audio_bus_idx = AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_idx))
	min_value = 0.0
	max_value = 2.0
	step      = 0.01
	$Label.text = slider_name
	value_changed.connect(func(new_value: float):
		AudioServer.set_bus_volume_db(audio_bus_idx, linear_to_db(new_value))
		PlayerData.auxilary_data.set_volume(audio_bus_name, value)
	)
