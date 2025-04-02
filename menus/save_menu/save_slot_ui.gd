class_name SaveSlotUI extends ButtonHover

@export_range(1, 3) var slot := 1

@onready var save_path = "user://save%s.tres" % slot
@onready var slot_name: Label = %SlotName
@onready var slot_desc: Label = %SlotDesc
@onready var empty: Label = %Empty

var save_resource: SaveTemplate

func _ready() -> void:
	super._ready()
	update_info()

func update_info() -> void:
	var save_exists = ResourceLoader.exists(save_path)
	if save_exists: save_resource = ResourceLoader.load(save_path)

	slot_name.text = "Slot %s" % slot
	if save_exists:
		empty.visible = false
		slot_desc.visible = true
		slot_desc.text = "Day %s" % save_resource.day
		self_modulate.a = 1.0
	else:
		empty.visible = true
		slot_desc.visible = false
		self_modulate.a = 0.5 # `modulate` is controlled by the entry animation; use `self_modulate` instead
