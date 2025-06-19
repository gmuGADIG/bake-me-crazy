extends CanvasLayer

#@onready var pause_container: VBoxContainer = %PauseContainer
@onready var anim: AnimationPlayer = %AnimationPlayer

var submenu: Control = null # the currently open sub-menu, e.g. the saves or options menu

@onready var buttons = [
	%OpenSaves,
	%CloseMenu,
	%ReturnMainMenu,
	%Options
]
var button_pos_y = []

func _ready() -> void:
	get_tree().paused = true # this is reset to false in _on_tree_exiting
	MainMusicPlayer.set_volume(0.3)
	
	for button in buttons:
		button_pos_y.push_back(button.position.y)
	
# for animating the panel scale
var scale_theta: float = 0.0
@onready var center_panel := %CenterPanel

func _process(_delta: float) -> void:
	if submenu != null: return # wait for the sub-menu to close first
	
	# close when the player presses "pause" again
	if Input.is_action_just_pressed("pause"):
		_on_close_menu_pressed()
		
	scale_theta += TAU * _delta * 0.7
	scale_theta = fmod(scale_theta, TAU)
	center_panel.scale.y = 1 + 0.01 * sin(scale_theta)
	center_panel.scale.x = 1 - 0.01 * cos(scale_theta)
	
	#for i in range(0, buttons.size()):
		#buttons[i].position.y = button_pos_y[i] + 1 * sin(scale_theta + i)

func open_submenu(submenu_scene: PackedScene) -> void:
	submenu = submenu_scene.instantiate()
	add_child(submenu)
	
	#pause_container.visible = false
	submenu.tree_exiting.connect(_on_submenu_close)

func _on_submenu_close() -> void:
	pass
	#pause_container.visible = true

func _on_tree_exiting() -> void:
	get_tree().paused = false
	MainMusicPlayer.set_volume(1.0)

func _on_open_saves_pressed() -> void:
	open_submenu(load("res://menus/save_menu/save_menu.tscn"))

func _on_close_menu_pressed() -> void:
	get_tree().paused = false
	anim.play(&"swipe_down")
	MainMusicPlayer.set_volume(1.0)
	await anim.animation_finished
	queue_free()

func _on_return_main_menu_pressed() -> void:
	SceneTransition.change_scene_to_file("res://menus/start_menu/main_menu.tscn")

func _on_options_pressed() -> void:
	open_submenu(load("res://menus/settings/settings_menu.tscn"))
