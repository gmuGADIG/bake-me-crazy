extends FoodStep

const STEVE = preload("res://temp_art/gartic/im_steve.png")
const SHOES = preload("res://temp_art/gartic/big_shoe_big_sad.png")

func start():
	add_ingredient(STEVE)
	# Nothing to do.
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		# Transform all steve children into shoes.
		for child in get_children():
			if child.sprite.texture == STEVE:
				# Transform the steve.
				child.sprite.texture = SHOES
				finished.emit(3, child)
				# Parent will clear rest of our children.
				return
