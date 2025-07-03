extends FoodStep

@onready var containers = [
	%Container,
	%Container2,
	%Container3,
	%Container4,
	%Container5,
	%Container6,
]

var score: float = 0.0
var _sent_signal: bool = false

func _process(delta: float) -> void:
	var done = true
	score = 0.0
	for container in containers:
		if not container.done:
			done = false
		score += container.score
	score /= containers.size()
	score = clamp(score, 1.0, 3.999)
	if done and not Input.is_action_pressed("minigame_interact"):
		if not _sent_signal:
			finished.emit(score)
			_sent_signal = true
