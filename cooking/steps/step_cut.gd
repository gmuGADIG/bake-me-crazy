extends FoodStep


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Cutting.set_point_position(1,$ToCut/CutGuide.shape.a)
	if(Input.is_mouse_button_pressed(1)):
		$Cutting.add_point(get_local_mouse_position());
		$Cutting/LastCutArea.position = get_local_mouse_position();
		
	
	

func _on_cut_end_area_entered(area: Area2D) -> void:
	var inLine = 0;
	for i in range($Cutting.get_point_count()):
		
		
		$Cutting/CutChecker.position = $Cutting.get_point_position(i)

		$Cutting/CutChecker.force_shapecast_update()
		
		if($Cutting/CutChecker.is_colliding()):
			#print($Cutting/CutChecker.get_collider())
			print($Cutting/CutChecker.position)
			inLine+=1;
	
	
	print(inLine)
	print($Cutting.get_point_count())
