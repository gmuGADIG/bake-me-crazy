extends Node2D

@export var lift_height : float = 100 ## How high above the path follow the icing bag is lifted when idling

##The amount of distance the mask needs to travel to go from 100% full to 0% full
#@export var piping_mask_travel_delta : float = 285.0
@onready var icing_mask_height : float = $IcingMasks/FullMask.texture.height

func _ready() -> void:
	self.position = $Icing.path_follow.global_position-Vector2(0,lift_height)

func set_icing_color(ingredient : IngredientData.IngredientType) -> void:
	var icing_color : Color
	match ingredient:
		IngredientData.IngredientType.CINNAMON:
			icing_color = Color.SIENNA
		IngredientData.IngredientType.ORANGE:
			icing_color = Color.ORANGE
		IngredientData.IngredientType.PISTACHIO:
			icing_color = Color.WEB_GREEN
		IngredientData.IngredientType.PORK:
			icing_color = Color.SADDLE_BROWN
		IngredientData.IngredientType.CHEESE:
			icing_color = Color.LIGHT_GREEN
		
	$Sprites/PipingBagFull.modulate = icing_color
	$Icing/Visual.default_color = icing_color

func is_lowered() -> bool:
	return absf(global_position.y- $Icing.path_follow.global_position.y) < 10

##Expects a percentage, between 100.0% and 0.0%, and displays the filling accordingly
func display_piping_bag(percentage_filled : float) -> void:
	$Icing.path_follow.progress_ratio = percentage_filled/100.0
	self.global_position.x =  $Icing.path_follow.global_position.x
	var mask_lerp_dist : float = clampf(percentage_filled/100.0,0.0,1.0)
	var mask_texture_size : float = lerpf(icing_mask_height,0,mask_lerp_dist)
	$IcingMasks/FullMask.texture.height = max(mask_texture_size,1)
	
	var offset : float = icing_mask_height-mask_texture_size
	$IcingMasks/FullMask.offset.y = 0.5*offset
	$IcingMasks/FullMask/FadeMask.offset.y = offset

func _input(event: InputEvent) -> void:
	if event.is_action("minigame_interact"):
		if event.is_pressed():
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(self,"position:y", $Icing.path_follow.global_position.y,0.25).set_trans(Tween.TRANS_QUAD)
		elif event.is_released():
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(self,"position:y", $Icing.path_follow.global_position.y-lift_height,0.25).set_trans(Tween.TRANS_QUAD)
