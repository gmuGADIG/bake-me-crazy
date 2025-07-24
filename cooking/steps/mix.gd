extends FoodStep
class_name Mix

var done = false
var count_mixes = 0
var last_mix_hitbox = -1

@onready var doneness: Sprite2D = %GoodnessPointer
@onready var mix_texture: Sprite2D = %MixTexture

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

	# tick our internal counter, making sure it doesn't go over 100
	count_mixes = min(count_mixes + 1, 100)
	
	# raise arrow
	var arrow_y = remap(count_mixes, 0, 100, 590, 20) # 590 and 20 are the lowest and highest heights of the arrow
	create_tween().set_trans(Tween.TRANS_SINE).tween_property(doneness, "position:y", arrow_y, .2)
	
	# spin texture
	var rads = remap(count_mixes, 0, 100, 0, PI * 10)
	create_tween().set_trans(Tween.TRANS_SINE).tween_property(mix_texture, "rotation", rads, .2)
