extends FoodStep
class_name ShapeStep
## Represents a [code]FoodStep[/code] in which you shape a piece of dough.
##
## This script detects applicable player motion and assess a score based on performance.

enum {PENDING, IN_PROGRESS, FINISHED}

## The [Control] node that will be used as the central point.
@export var origin : Control

func _ready() -> void:
	pass

func pre_animation():
	pass
	
func start():
	pass

func _process(delta: float) -> void:
	pass
