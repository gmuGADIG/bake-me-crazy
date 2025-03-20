extends FoodStep


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Cutting.set_point_position(1,$ToCut/CutGuide.shape.a)
	if(Input.is_mouse_button_pressed(1)):
		$Cutting.add_point(get_local_mouse_position());
		
	
	
			
	


func _on_last_cut_area_area_entered(area: Area2D) -> void:
	var inLine = 0;
	for i in range($Cutting.get_point_count()):
		if(Geometry2D.is_point_in_polygon($Cutting.get_point_position(i),$ToCut/CutGuide.shape)):
			inLine+=1
	print(inLine)
	
