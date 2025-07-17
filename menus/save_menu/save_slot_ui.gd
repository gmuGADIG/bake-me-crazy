class_name SaveSlotUI extends ButtonHover

@export_range(1, 3) var slot := 1

@onready var save_path = "user://save_v2_%s.tres" % slot
@onready var slot_name: Label = %SlotName
@onready var slot_desc: Label = %SlotDesc
@onready var empty: Panel = %EmptyPanel

var save_resource: SaveTemplate

func _ready() -> void:
	super._ready()
	update_info()

## Provide just_saved_save if we just saved this save slot. In that case,
## update_info() will read the current information from that save. Otherwise,
## it will read the data from the filesystem.
##
## Note that just_saved_save will have duplicate(true) called on it, so that
## we get a deep copy, like we just saved-loaded.
func update_info(just_saved_save: SaveTemplate = null) -> void:
	var save_exists = ResourceLoader.exists(save_path)
	if just_saved_save != null:
		save_resource = just_saved_save.duplicate(true)
		await get_tree().process_frame
		# Reload the save from the file system ASAP, so that we get a true
		# deep copy rather than a fake one.
		save_resource = ResourceLoader.load(save_path)
		
	elif save_exists: save_resource = ResourceLoader.load(save_path)

	slot_name.text = "Slot %s" % slot
	if save_exists:
		empty.visible = false
		slot_desc.visible = true
		slot_desc.text = "Day %s" % save_resource.day
		#self_modulate.a = 1.0
		#self_modulate = Color(1, 1, 1, 1)
		
		original_scale = Vector2(1.0, 1.0)
	else:
		empty.visible = true
		slot_desc.visible = false
		#self_modulate = Color(0.9, 0.9, 0.9, 1.0)
		
		# Set button_hover base scale
		original_scale = Vector2(0.97, 0.97)
		#self_modulate.a = 0.5 # `modulate` is controlled by the entry animation; use `self_modulate` instead
