extends CanvasItem

func _ready() -> void:
	self.rotation = randf() * TAU

func _process(delta: float) -> void:
	self.rotation += delta * TAU / 15
