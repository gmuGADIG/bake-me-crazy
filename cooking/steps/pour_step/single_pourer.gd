extends Area2D
class_name SinglePourer

@onready var poured_in := %PouredIn

const UNPOURED := 118.0
const   POURED := 34.0
const POUR_PERFECT := 64.0
const POUR_READY   := 72.0

var pour_percent := 0.0
var pour_rate := 0.1

var pour_rate_multiplier := 1.0

var done := false
var score := 1.0

# In order to support multiple texture scales for the SinglePourer sprite, we need to also
# adjust our gameplay-relevant constant values (measured relative to the 256x256 sprite at the
# reference scale of 0.734) to match the new texture scale.
var tex_scale := 0.734
const TEX_SCALE_REF := 0.734

@onready var poured_in_ref_scale = %PouredIn.scale

func unpoured() -> float:
	return UNPOURED * TEX_SCALE_REF / tex_scale
func poured() -> float:
	return POURED * TEX_SCALE_REF / tex_scale
func pour_perfect() -> float:
	return POUR_PERFECT * TEX_SCALE_REF / tex_scale
func pour_ready() -> float:
	return POUR_READY * TEX_SCALE_REF / tex_scale	

func set_container_texture(texture: Texture2D) -> void:
	%SinglePourer.texture = texture
	
	tex_scale = (256.0 / texture.get_width()) * TEX_SCALE_REF
	
	%SinglePourer.scale = Vector2(tex_scale, tex_scale)
	%PouredIn.scale = poured_in_ref_scale * TEX_SCALE_REF / tex_scale
	
	# Reset the poured_in sprite for initial scene load
	poured_in.position.y = lerp(unpoured(), poured(), pour_percent)

func _ready() -> void:
	%PerfectPourRef.queue_free()
	
	poured_in.position.y = unpoured()
	body_entered.connect(func(body):
		var delta = 0.025 # Lets us easily test this code in _process(?)
		pour_percent = min(pour_percent + delta * pour_rate * pour_rate_multiplier, 1.0)
		pour_rate += delta * 0.25
		
		body.queue_free()
	)

func _compute_score() -> void:
	var y: float = poured_in.position.y
	done = (y <= pour_ready())
	score = 3.999 - 0.2 * abs(y - pour_perfect())
	score = clamp(score, 1.0, 3.999)

func _process(delta: float) -> void:
	poured_in.position.y = lerp(unpoured(), poured(), pour_percent)
	_compute_score()
