extends Camera2D

func _ready() -> void:
	# when the camera first appears, instantly move it where it should be.
	# this prevents starting somewhere else and moving to the right spot over time.
	reset_smoothing.call_deferred()
