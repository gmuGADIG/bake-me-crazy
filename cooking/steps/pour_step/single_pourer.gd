extends Sprite2D
class_name SinglePourer

@onready var poured_in := %PouredIn

const UNPOURED := 118.0
const   POURED := 34.0

var pour_percent := 0.0
var pour_rate := 0.1

func _ready() -> void:
	poured_in.position.y = UNPOURED

func _process(delta: float) -> void:
	if Input.is_action_pressed("minigame_interact"):
		pour_percent = min(pour_percent + delta * pour_rate, 1.0)
		pour_rate += delta * 0.25
		poured_in.position.y = lerp(UNPOURED, POURED, pour_percent)
