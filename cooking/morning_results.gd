extends Control

@onready var stars := %StarContainer.get_children()

signal results_done()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	if get_tree().current_scene == self:
		await get_tree().create_timer(1).timeout
		show_results(3)

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
	if MorningShift.instance != null:
		%Food.texture = MorningShift.instance.current_recipe.texture

	set_active(clamp(score, 0, len(stars)))
	visible = true
	modulate.a = 0.
	create_tween().tween_property(self, "modulate:a", 1., .75)

func _on_button_pressed() -> void:
	# This, at the end of the day, moves to the next minigame. Then, MorningShift
	# can handle what happens when all minigames are done.
	results_done.emit()
	visible = false
	#SceneTransition.change_scene_to_file("res://free_roam/world/lunch_break/lunch_break.tscn")
