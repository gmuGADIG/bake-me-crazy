extends Control

@onready var stars := %StarContainer.get_children()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	set_active(1)

func set_active(num: int) -> void:
	for star in stars:
		star.visible = num > 0
		num -= 1

## returns the number of active stars
func num_active() -> int:
	# count every visible star
	return stars.reduce(
		func(acc,e: Node): return acc + (1 if e.visible else 0), 
		0)
func show_results(score: int) -> void:
	set_active(clamp(score, 0, len(stars)))
	visible = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://free_roam/world/lunch_break/lunch_break.tscn")
