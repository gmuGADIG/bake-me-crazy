extends Area2D
class_name SinglePourer

@onready var poured_in := %PouredIn

const UNPOURED := 118.0
const   POURED := 34.0

var pour_percent := 0.0
var pour_rate := 0.1

func _ready() -> void:
	poured_in.position.y = UNPOURED
	body_entered.connect(func(body):
		var delta = 0.05 # Lets us easily test this code in _process(?)
		pour_percent = min(pour_percent + delta * pour_rate, 1.0)
		pour_rate += delta * 0.25
		
		body.queue_free()
	)

func _process(delta: float) -> void:
	poured_in.position.y = lerp(UNPOURED, POURED, pour_percent)
