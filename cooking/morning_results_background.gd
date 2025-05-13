@tool
extends CanvasItem

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		(material as ShaderMaterial).set_shader_parameter("target_pos", $Target.position)
