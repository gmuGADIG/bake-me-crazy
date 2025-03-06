extends Node2D


var foods : Array[String] = ["taco1","taco2","taco3","taco4"]
var flavors : Array[String] = ["pesto","ketchup","blueberry"]

var requestedFood : String
var requestedFlavor : String


enum Stage {
	FOOD_SELECT,
	FLAVOR_SELECT,
	FLAVOR_TOWN
}

var currentStage : Stage 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/FoodSelect.visible = true
	$CanvasLayer/FlavorSelect.visible = false
	
	new_order()


func new_order() -> void:
	##Reset all node states to default
	currentStage = Stage.FOOD_SELECT
	$DivorceWoman.modulate.a = 0
	$CanvasLayer/FoodSelect/VBoxContainer.position.x = 1162
	$CanvasLayer/FlavorSelect/VBoxContainer.position.x = 1162
	
	
	
	
	##Make new person visible
	var tween = get_tree().create_tween()
	tween.tween_property($DivorceWoman, "modulate:a", 1, 0.8).set_trans(Tween.TRANS_EXPO)
	##Selects order
	requestedFood = foods.pick_random()
	requestedFlavor = flavors.pick_random()
	
	print("food: " + requestedFood)
	print("flavour: " + requestedFlavor)
	
	##Request speech bubble appears
	##TODO: This.
	
	##Food buttons slide in
	tween.tween_property($CanvasLayer/FoodSelect/VBoxContainer, "position:x", 1052, 0.3	).set_trans(Tween.TRANS_QUAD)
	
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



##Each of the buttons in the inspector pass in an index argument for the foods array
func _on_food_selected(food_index: int) -> void:
	if currentStage != Stage.FOOD_SELECT:
		return
	
	currentStage = Stage.FLAVOR_SELECT
	
	var food : String = foods[food_index]
	print(food)
	
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/FoodSelect/VBoxContainer, "position:x", 1162, 0.3	).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($CanvasLayer/FlavorSelect/VBoxContainer, "position:x", 1052, 0.3).set_trans(Tween.TRANS_QUAD)

func _on_flavor_selected(flavor_index: int) -> void:
	pass
