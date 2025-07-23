extends RichTextLabel

const center_y := 648. / 2
@onready var target := center_y - (size.y / 2)

var speed := 0.
var stopped := false

func _ready() -> void:
	await (get_parent() as Credits).scrolling_started
	speed = %Scroller.scroll_speed

func _process(delta: float) -> void:
	if stopped: return

	position.y = move_toward(
		position.y,
		target,
		delta * speed
	)
	
	if position.y == target:
		stopped = true
		await get_tree().create_timer(5.).timeout
		if OS.has_feature("movie"):
			get_tree().quit()
		else:
			SceneTransition.change_scene_to_file("res://menus/start_menu/main_menu.tscn")
