extends CanvasLayer

@onready var pause_container: VBoxContainer = %PauseContainer

var submenu: Control = null # the currently open sub-menu, e.g. the saves or options menu

func _ready() -> void:
	get_tree().paused = true # this is reset to false in _on_tree_exiting

func _process(_delta: float) -> void:
	if submenu != null: return # wait for the sub-menu to close first
	
	# close when the player presses "pause" again
	if Input.is_action_just_pressed("pause"):
		queue_free()

func open_submenu(submenu_scene: PackedScene) -> void:
	submenu = submenu_scene.instantiate()
	add_child(submenu)
	
	pause_container.visible = false
	submenu.tree_exiting.connect(_on_submenu_close)

func _on_submenu_close() -> void:
	pause_container.visible = true

func _on_tree_exiting() -> void:
	get_tree().paused = false

func _on_open_saves_pressed() -> void:
	open_submenu(load("res://menus/save_menu/save_menu.tscn"))

func _on_close_menu_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_return_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/start_menu/main_menu.tscn")

func _on_options_pressed() -> void:
	open_submenu(load("res://menus/settings/settings_menu.tscn"))
