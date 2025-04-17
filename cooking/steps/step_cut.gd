extends FoodStep

var child = 0;
# Called when the node enters the scene tree for the first time.
var children = []
func _ready() -> void:
	pass # Replace with function body.
	children = $ToCut.get_children()
	
	for child in children:
		$ToCut.remove_child(child)
		
	$ToCut.add_child(children[0])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Cutting.set_point_position(1,$ToCut/CutGuide.shape.a)
	if(Input.is_mouse_button_pressed(1)):
		$Cutting.add_point(get_local_mouse_position());
		$Cutting/LastCutArea.position = get_local_mouse_position();
		
	
	

func _on_cut_end_area_entered(area: Area2D) -> void:
	var inLine = 0;
	for i in range($Cutting.get_point_count()):
		
		
		$Cutting/CutChecker.position = $Cutting.get_point_position(i)

		$Cutting/CutChecker.force_shapecast_update()
		
		
		if($Cutting/CutChecker.is_colliding()):
			#print($Cutting/CutChecker.get_collider(0))
			#print($Cutting/CutChecker.position)
			
			inLine+=1;
	
	
	#print(inLine)
	#print($Cutting.get_point_count())
	print(child)
	$ToCut.remove_child(children[child])
	
	child+=1
	$ToCut.add_child(children[child])
	
	$Cutting.clear_points()

func _exit_tree():
	for child in children:
		child.queue_free()
		
	
	
	
