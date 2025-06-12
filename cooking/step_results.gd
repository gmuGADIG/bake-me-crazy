extends Control

signal finised

@export var result_grow_time = 0.25
@export var result_full_size_time = 0.25
@export var result_full_leave_time = 0.25

func set_display_text(score :float) -> void:
	var num_stars : int = round(score)
	
	match num_stars:
		1:
			$Control/VBoxContainer/StarContainer/Star1.hide()
			$Control/VBoxContainer/StarContainer/Star2.show()
			$Control/VBoxContainer/StarContainer/Star3.hide()
			$Control/VBoxContainer/RichTextLabel.text = "[center][i]Poor[/i][/center]"
		2:
			$Control/VBoxContainer/StarContainer/Star1.show()
			$Control/VBoxContainer/StarContainer/Star2.hide()
			$Control/VBoxContainer/StarContainer/Star3.show()
			$Control/VBoxContainer/RichTextLabel.text = "[center][i]Good[/i][/center]"
		3:
			$Control/VBoxContainer/StarContainer/Star1.show()
			$Control/VBoxContainer/StarContainer/Star2.show()
			$Control/VBoxContainer/StarContainer/Star3.show()
			$Control/VBoxContainer/RichTextLabel.text = "[center][i]Perfect![/i][/center]"
			
func display_results(score : float) -> void:
	$Control.position = self.size/2
	$Control.scale = Vector2.ZERO
	set_display_text(score)
	self.show()
	
	var tween = create_tween()
	
	tween.tween_property($Control, "scale", Vector2(1,1), result_grow_time).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	
	await get_tree().create_timer(result_full_size_time).timeout
	
	var tween2 = create_tween()
	tween2.tween_property($Control, "position:y", $Control.position.y+self.size.y, result_grow_time).set_trans(Tween.TRANS_CUBIC)
	await tween2.finished
	
	
	
	finised.emit()
	
