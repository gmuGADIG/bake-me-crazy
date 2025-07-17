extends Control

@export var can_save := true

@onready var bottom_buttons: HBoxContainer = $BottomButtons
@onready var unselected_placeholder: Label = %UnselectedPlaceholder
@onready var load_save_button: Button = %LoadSaveButton
@onready var write_save_button: Button = %WriteSaveButton

@onready var load_save_box: Control = %LoadSaveBox
@onready var write_save_box: Control = %WriteSaveBox

@onready var load_save_label = %LoadSaveLabel
@onready var write_save_label = %WriteSaveLabel

var currently_selected_slot: SaveSlotUI
var _tween: Tween ## current tween, used for raising the bottom buttons

func _ready() -> void:
	var in_tween := create_tween()
	position = Vector2(1193, 709)
	#in_tween.tween_property(self, "position", Vector2(629, -79), 0.2).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_LINEAR)
	in_tween.tween_property(self, "position", Vector2.ZERO,      0.3).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_LINEAR)

func _process(delta: float) -> void:
	## go back with the back buttton
	if Input.is_action_just_pressed("pause"):
		_on_back_button_pressed()
		return
	
	## update bottom buttons based on the currently focused object
	var current_focus = get_viewport().gui_get_focus_owner() as SaveSlotUI
	if currently_selected_slot != current_focus:
		currently_selected_slot = current_focus
		update_bottom_buttons()
		
		# animate position
		const LOWER_POSITION = 650.0
		const RAISE_POSITION = 505.0
		if _tween != null: _tween.kill()
		bottom_buttons.position.y = LOWER_POSITION
		_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		_tween.tween_property(bottom_buttons, "position:y", RAISE_POSITION, 0.5)

# adjusts the contents and visibilty of the bottom buttons based on `currently_selected_slot`
func update_bottom_buttons() -> void:
	if currently_selected_slot == null:
		unselected_placeholder.visible = true
		load_save_box.visible = false
		write_save_box.visible = false
	else:
		unselected_placeholder.visible = false
		write_save_box.visible = true
		
		if currently_selected_slot.save_resource == null:
			load_save_box.visible = false
		else:
			load_save_box.visible = true
			load_save_label.text = "Load Slot %s" % currently_selected_slot.slot
		
		if not can_save:
			write_save_box.visible = false
		else:
			write_save_box.visible = true
			write_save_label.text = "Save to Slot %s" % currently_selected_slot.slot

func _on_back_button_pressed() -> void:
	queue_free()

func _on_load_save_button_pressed() -> void:
	print("[save_system] Loading!")
	var save_resource = currently_selected_slot.save_resource
	print("[save_system] ", save_resource.inventory)
	for item in save_resource.inventory:
		print("[save_system] ", '"', item._data_resource_path, '"')
	PlayerData.load_file(save_resource)

func _on_write_save_button_pressed() -> void:
	PlayerData.data.scene_path = get_tree().current_scene.scene_file_path
	PlayerData.data.dialogic_blob = Dialogic.get_full_state()
	print("[save_system] Saving!")
	print("[save_system] ", PlayerData.data.inventory)
	for item in PlayerData.data.inventory:
		print("[save_system] ", '"', item._data_resource_path, '"')
	print("[save_system] ", PlayerData.data.dialogic_blob)
	var result = ResourceSaver.save(PlayerData.data, currently_selected_slot.save_path)
	print("save to path: ", currently_selected_slot.save_path)
	assert(result == 0)
	
	currently_selected_slot.update_info(PlayerData.data)
