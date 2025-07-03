extends Area2D
class_name SinglePourer

@onready var poured_in := %PouredIn

const UNPOURED := 118.0
const   POURED := 34.0
const POUR_PERFECT := 64.0
const POUR_READY   := 72.0

var pour_percent := 0.0
var pour_rate := 0.1

var done := false
var score := 1.0

func _ready() -> void:
	poured_in.position.y = UNPOURED
	body_entered.connect(func(body):
		var delta = 0.025 # Lets us easily test this code in _process(?)
		pour_percent = min(pour_percent + delta * pour_rate, 1.0)
		pour_rate += delta * 0.25
		
		body.queue_free()
	)

func _compute_score() -> void:
	var y: float = poured_in.position.y
	done = (y <= POUR_READY)
	score = 3.999 - 0.2 * abs(y - POUR_PERFECT)
	score = clamp(score, 1.0, 3.999)

func _process(delta: float) -> void:
	poured_in.position.y = lerp(UNPOURED, POURED, pour_percent)
	_compute_score()
