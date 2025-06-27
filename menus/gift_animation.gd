class_name GiftAnimation
extends CanvasLayer

var prepared := false
var flavor_liked := true

@onready var food_texture_rect: TextureRect = %FoodTextureRect
@onready var ingredient_texture_rect: TextureRect = %IngredientTextureRect
@onready var missing_ingredient_texture_rect: TextureRect = %MissingIngredientTextureRect
@onready var ingredient_heart: Sprite2D = %IngredientHeart
@onready var missing_heart: Sprite2D = %MissingHeart

func prepare(flavor_liked: bool):
	prepared = true
	self.flavor_liked = flavor_liked

func _ready() -> void:
	if get_tree().current_scene != self and not prepared:
		assert(false, "GiftAnimation.prepare not called!")
	
	var food_data := GiftPrompt.selected_food_data
	if food_data != null:
		food_texture_rect.texture = food_data.image
		
		var quality: int = Dialogic.VAR.read_only.gift_quality
		var lut := [
			[%Star1,%Heart1],
			[%Star2,%Heart2],
			[%Star3,%Heart3],
		]
		for nodes in lut:
			if quality <= 0:
				for n in nodes: 
					print("hiding ", n.get_path())
					n.hide()
			else:
				for n in nodes: 
					print("showing ", n.get_path())
					n.show()
			
			quality -= 1
		
		var ingredient := food_data.ingredient
		if ingredient:
			ingredient_texture_rect.texture = \
				ingredient.image if ingredient.image != null else load("uid://c2pdk1044618r")
			ingredient_heart.visible = flavor_liked
			missing_heart.visible = not flavor_liked
			missing_ingredient_texture_rect.visible = false
		else:
			missing_ingredient_texture_rect.visible = true
			ingredient_texture_rect.visible = false
			ingredient_heart.visible = false
			missing_heart.visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
