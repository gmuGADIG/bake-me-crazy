class_name Recipe extends Resource

@export var name = ""
@export_multiline var instructions = ""
@export var minigame: PackedScene
@export var is_locked = false

@export var variants: Array[RecipeVariant]
