extends Node2D

@export var egg_line : PackedScene
@export var egg_drop_speed : float

var lines : Array[Line2D]

var prev_pos : Vector2
var prev_thickness : float = 1

func _update_egg_stream(delta : float, ladle_pos : Vector2, x_dist : float) -> void:
	if Input.is_action_just_pressed("minigame_interact"):
		start_line(ladle_pos)
	elif Input.is_action_pressed("minigame_interact"):
		var new_thickness : float = clamp(x_dist*delta*1.5,0,1)
		continue_line(ladle_pos, new_thickness)
	elif Input.is_action_just_released("minigame_interact"):
		continue_line(ladle_pos ,0)
	
	##Drop the existing lines
	for line in lines:
		line.move_local_y(delta*egg_drop_speed)
	
	if lines.size() > 0 && lines[0].position.y > 250:
		var removed_line = lines[0]
		lines.remove_at(0)
		removed_line.queue_free()
		
func start_line(ladle_pos : Vector2) -> void:
	create_line(ladle_pos,ladle_pos,0,0)
	pass

func continue_line(ladle_pos : Vector2, new_thickness : float) -> void:
	var actual_prev_pos : Vector2 = prev_pos+Vector2(0,lines[lines.size()-1].position.y)
	create_line(actual_prev_pos,ladle_pos,prev_thickness,new_thickness)
	
func create_line(p1 : Vector2, p2 : Vector2, thickness1 : float, thickness2 : float) -> void:
	var new_egg_line : Line2D = egg_line.instantiate()
	new_egg_line.width_curve = Curve.new()
	
	new_egg_line.add_point(p1)
	new_egg_line.add_point(p2)
	new_egg_line.width_curve.add_point(Vector2(0,thickness1))
	new_egg_line.width_curve.add_point(Vector2(1,thickness2))
	print(new_egg_line.width_curve.point_count)
	
	add_child(new_egg_line)
	lines.append(new_egg_line)
	
	
	prev_pos = p2
	prev_thickness = thickness2
