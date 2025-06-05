extends FoodStep

# east start: 0.925
# west start: 0.935

# emitted when the player releases the mouse after folding (for sfx)
signal folded

enum Direction {
	Right = 1,
	Left = 3
}

var used_directions := {}

@onready var bottom_dough: Sprite2D = %BottomDough
@onready var dough_overlay: Sprite2D = %DoughOverlay
@onready var left_arrow: Sprite2D = %LeftArrow
@onready var right_arrow: Sprite2D = %RightArrow

@onready var dough_overlay_parent: Node = dough_overlay.get_parent()

@onready var bottom_dough_shader: ShaderMaterial = bottom_dough.material
var left_overlay_shader: ShaderMaterial
var right_overlay_shader: ShaderMaterial

var done := false

func new_overlay(d: Direction) -> ShaderMaterial:
	var sprite: Sprite2D = dough_overlay.duplicate()
	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_parameter("fold_type", d)
	dough_overlay_parent.add_child(sprite)

	return sprite.material

func get_overlay(d: Direction) -> ShaderMaterial:
	if d == Direction.Left:
		return left_overlay_shader
	return right_overlay_shader

func get_arrow(d: Direction) -> Sprite2D:
	if d == Direction.Left:
		return right_arrow
	return left_arrow

func direction_to_string(d: Direction) -> String:
	match d:
		Direction.Right: return "west"
		Direction.Left: return "east"
	return ""

func _ready() -> void:
	dough_overlay_parent.remove_child(dough_overlay)

var last_mouse_pos: Vector2 = -Vector2.ONE
var dragging := false
var direction: Direction = -1
func _process(_delta: float) -> void:
	if done: return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not dragging:
			dragging = true
			last_mouse_pos = get_global_mouse_position()
		else:
			var mouse_diff := get_global_mouse_position() - last_mouse_pos
			last_mouse_pos = get_global_mouse_position()

			if direction == -1:
				# find the direction
				if mouse_diff.x == 0: return
				direction = Direction.Right if mouse_diff.x > 0 else Direction.Left
				
				if direction == Direction.Left and left_overlay_shader == null:
					left_overlay_shader = new_overlay(Direction.Right)
					left_overlay_shader.set_shader_parameter("fold", 0.935)

				if direction == Direction.Right and right_overlay_shader == null:
					right_overlay_shader = new_overlay(Direction.Left)
					right_overlay_shader.set_shader_parameter("fold", 0.925)

			var fold: float = get_overlay(direction).get_shader_parameter("fold")
			var shader_diff := absf(mouse_diff.x) / 512
			var new_fold := move_toward(fold, .65, shader_diff / 2)
			get_overlay(direction).set_shader_parameter("fold", new_fold)
			bottom_dough_shader.set_shader_parameter(direction_to_string(direction), new_fold)

			var arrow := get_arrow(direction)
			if arrow.modulate.a == 1:
				var tween := create_tween()
				tween.tween_property(arrow, "modulate:a", 0., .35)

			if new_fold < .7:
				used_directions[direction] = null
				if used_directions.size() == 2:
					finished.emit(3)
					done = true
					print("done!")
	else:
		dragging = false
		direction = -1
		last_mouse_pos = -Vector2.ONE

		folded.emit()



func _exit_tree() -> void:
	dough_overlay.queue_free()
