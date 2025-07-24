class_name PipeLineIcing extends Node

enum IcingSize {
	NONE,
	TOO_SMALL,
	JUST_RIGHT,
	TOO_LARGE,
}

#var icing_positions : Array[float]
#var icing_thicknesses : Array[float]

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D

func _ready() -> void:
	##Pre-populate the line with 100 points
	for i : float in range(100):
		path_follow.progress_ratio = i*0.01
		$Visual.add_point(path_follow.position)
		$Visual.width_curve.add_point(Vector2(path_follow.progress_ratio,0))
	path_follow.progress_ratio = 0

func draw_icing_line(icing_size : IcingSize):
	var line_thickness : float
	match icing_size:
		IcingSize.TOO_LARGE:
			line_thickness = 0.3
		IcingSize.JUST_RIGHT:
			line_thickness = 0.6
		IcingSize.TOO_SMALL:
			line_thickness = 1
	
	var width_curve_index : int = roundi(path_follow.progress_ratio*99)
	
	
	for i : int in range(width_curve_index,0,-1):
		var width_at_index : float = $Visual.width_curve.get_point_position(i).y
		if is_zero_approx(width_at_index):
			$Visual.width_curve.set_point_value(width_curve_index,line_thickness)
		else:
			break
	
		
	
	#icing_positions.append(path_follow.progress_ratio)
	#icing_thicknesses.append(line_thickness)
	#$Visual.add_point(path_follow.global_position)
	#
	#assert(icing_positions.size() == icing_thicknesses.size())
	#assert(icing_thicknesses.size() == $Visual.get_point_count())
	#
	#$Visual.width_curve.clear_points()
	#var new_curve : Curve = Curve.new()
	#for i in range(icing_thicknesses.size()):
		#new_curve.add_point(Vector2(icing_positions[i]/path_follow.progress_ratio,icing_thicknesses[i]))
	#$Visual.width_curve = new_curve
	#
	#
	#var pl : PackedStringArray
	#for i in range($Visual.width_curve.get_point_count()):
		#pl.append(str($Visual.width_curve.get_point_position(i)))
	#print(pl)	
	#
	
