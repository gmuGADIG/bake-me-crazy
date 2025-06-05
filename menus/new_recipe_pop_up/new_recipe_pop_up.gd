class_name NewRecipePopUp extends CanvasLayer

@onready var food_name: RichTextLabel = %FoodName
@onready var glow_spinner: TextureRect = %GlowSpinner
@onready var food_image: TextureRect = %FoodImage

func _process(delta: float) -> void:
	glow_spinner.rotation += delta * .3
	food_image.position.y += sin(Time.get_ticks_msec() / 1000.0) * delta * 10.0

func set_recipe(recipe: FoodGroup) -> void:
	food_image.texture = recipe.variants[0].image
	food_name.text += recipe.display_name

func _on_ok_button_pressed() -> void:
	queue_free()
