extends Control

@onready var stars := %StarContainer.get_children()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(func ():
		set_active(1)
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_active(num: int) -> void:
	for star in stars:
		star.visible = num > 0
		num -= 1

func num_active() -> int:
	return stars.reduce(
		func(acc,e: Node): return acc + (1 if e.visible else 0), 
		0)
func show_results(score: int) -> void:
	set_active(clamp(score, 0, len(stars)))
	visible = true
