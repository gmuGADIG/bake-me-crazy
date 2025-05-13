extends FoodStep

var active_child_idx = 0
var collision_shapes: Array[CollisionShape2D]
var grades: Array[float]

@onready var cut_line: Line2D = %Cutting
@onready var cut_checker: ShapeCast2D = %CutChecker

func _ready() -> void:
	collision_shapes.assign($ToCut.get_children())
	
	for child in collision_shapes:
		# safety asserts
		assert(child != null)
		assert(child is CollisionShape2D)
		assert(child.shape is RectangleShape2D)

		$ToCut.remove_child(child)
		
	$ToCut.add_child(collision_shapes[0])

func _grade_cutting_points() -> float:
	# test accuracy
	# TODO: there's probably a more performant way to do this
	# but ¯\_(ツ)_/¯
	var hit := 0.
	for point in cut_line.points:
		cut_checker.position = point
		cut_checker.force_shapecast_update()

		if cut_checker.is_colliding():
			hit += 1.

	var hit_rate := hit / cut_line.points.size()
	
	# test length
	var shape: RectangleShape2D = collision_shapes[active_child_idx].shape
	var target_length := shape.size.y
	var actual_length := cut_line.points[0].distance_to(cut_line.points[-1])

	var length_score: float
	if actual_length < target_length:
		length_score = inverse_lerp(0, target_length, actual_length)
	else:
		length_score = inverse_lerp(target_length * 2, target_length, actual_length)

	length_score = clampf(length_score, 0, 1)
	
	print("hit_rate = %.2f; length_score = %.2f" % [hit_rate, length_score])
	return hit_rate * length_score

var done := false
func _process(delta: float) -> void:
	# TODO: change the cursor instead
	$Cutting/LastCutArea.position = get_local_mouse_position();

	if done: return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pos := get_local_mouse_position()
		if $Cutting.points.is_empty():
			$Cutting.add_point(pos)
		# prevent slow cursor movement causing a crowding of points
		elif $Cutting.points[-1].distance_to(pos) > 5:
			$Cutting.add_point(pos)

	# if player done cutting
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not $Cutting.points.is_empty():
		var new_line := Line2D.new()
		new_line.default_color = Color.BLACK
		new_line.points = $Cutting.points
		add_child(new_line)

		grades.push_back(_grade_cutting_points())
		print("grade = %.2f" % grades[-1])
		$Cutting.clear_points()
		active_child_idx += 1


		if active_child_idx == collision_shapes.size():
			# godot doesn't have a sum or mean function >:(
			var average_grade = grades.reduce(func(acc, x): return acc + x, 0) / grades.size()
			finished.emit(average_grade * 3)
			done = true
		else:
			$ToCut.remove_child(collision_shapes[active_child_idx - 1])
			$ToCut.add_child(collision_shapes[active_child_idx])

# free memory before we leave
func _exit_tree():
	for child in collision_shapes:
		child.queue_free()
