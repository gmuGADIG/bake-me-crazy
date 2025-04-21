extends Resource
class_name Song

@export var loop_start: float
@export var loop_end: float
@export var song_file: Resource
@export var fade_period: float
@export var fade_in_curve: Curve
@export var fade_out_curve: Curve

func _init(l_start = 0.0, l_end = 0.0, f_period=0.2):
	loop_start = l_start
	loop_end = l_end
	fade_period = f_period
	song_file = null
	fade_in_curve = Curve.new()
	fade_out_curve = Curve.new()
