extends Node2D



#TODO: Replace these with the actual food items and flavors
var foods : Array[FoodItem] = ["ice cream","salad","pizza","taco"]
var flavors : Array[FoodItem] = ["pesto","ketchup","blueberry"]

var requestedFood : String
var requestedFlavor : String

var selectedFood : String
var selectedFlavor : String


enum Stage {
	FOOD_SELECT,
	FLAVOR_SELECT,
	FLAVOR_TOWN
}

var currentStage : Stage 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
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
	
	selectedFood = foods[food_index]
	print(selectedFood)
	
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/FoodSelect/VBoxContainer, "position:x", 1162, 0.3	).set_trans(Tween.TRANS_QUAD)
	#TODO: Make the food slide in at the same time as the food select disapears
	
	tween.tween_property($CanvasLayer/FlavorSelect/VBoxContainer, "position:x", 1052, 0.3).set_trans(Tween.TRANS_QUAD)


##Each of the buttons in the inspector pass in an index argument for the flavours array
func _on_flavor_selected(flavor_index: int) -> void:
	if currentStage != Stage.FLAVOR_SELECT:
		return
	
	currentStage = Stage.FLAVOR_TOWN
	
	selectedFlavor = flavors[flavor_index]
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/FlavorSelect/VBoxContainer, "position:x", 1162, 0.3).set_trans(Tween.TRANS_QUAD)
	
	pass
