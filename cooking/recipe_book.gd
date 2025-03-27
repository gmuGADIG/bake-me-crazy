extends Control

@export var recipes : Array[Recipe]
@onready var food_name = $"Book/page Left/Food name"

func _ready() -> void:
	food_name.text = recipes[0].name
