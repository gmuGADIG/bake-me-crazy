extends FoodStep
class_name Mix

var done = false
var count_mixes = 0
var last_mix_hitbox = -1

@onready var doneness: Sprite2D = %GoodnessPointer

func _process(_delta: float) -> void:
	if done: return
	if Input.is_action_just_released("minigame_interact"):
		if count_mixes < 4: return

		var dist_from_center := clampf(absf(count_mixes - 50), 0, 50)
		var normalized_dist := remap(dist_from_center, 0, 50, 0, 1)
		var score := lerpf(3, 1, normalized_dist)

		print("[mix] score = ", score)
		finished.emit(score)
		done = true


func _on_area_2d_mouse_entered(id: int) -> void:
	if done: return
	if not Input.is_action_pressed("minigame_interact"): return
	if last_mix_hitbox == id: return

	last_mix_hitbox = id

	# raise the left side arrow, making sure it doesn't overflow
	doneness.position.y = max(-250, doneness.position.y - 5)
	# tick our internal counter, making sure it doesn't go over 100
	count_mixes = min(count_mixes + 1, 100)
