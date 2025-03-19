extends Button
var player
@export var skins : Array[String]
var current_skin:=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $"../Path2D/Player"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	current_skin+=1
	if(current_skin>= skins.size()):
		current_skin = 0
	player._set_sprite(skins[current_skin])
	pass # Replace with function body.
