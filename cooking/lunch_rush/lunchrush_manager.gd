extends Node2D



#TODO: Replace these with the actual food items and flavors
@export var foods : Array[FoodItem]
@export var flavors : Array[FoodItem]

var requestedFood : FoodItem
var requestedFlavor : FoodItem

var selectedFood : FoodItem
var selectedFlavor : FoodItem


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
	
	##Selects order
	requestedFood = foods.pick_random()
	requestedFlavor = flavors.pick_random()
	
	print("food: " + requestedFood.display_name)
	print("flavour: " + requestedFlavor.display_name)
	
	
	##Sets all of the images
	$CanvasLayer/FoodSelect/VBoxContainer/Food1.icon = foods[0].image
	$CanvasLayer/FoodSelect/VBoxContainer/Food2.icon = foods[1].image
	$CanvasLayer/FoodSelect/VBoxContainer/Food3.icon = foods[2].image
	$CanvasLayer/FoodSelect/VBoxContainer/Food4.icon = foods[3].image
	
	$CanvasLayer/FlavorSelect/VBoxContainer/Flavor1.icon = flavors[0].image
	$CanvasLayer/FlavorSelect/VBoxContainer/Flavor2.icon = flavors[1].image
	$CanvasLayer/FlavorSelect/VBoxContainer/Flavor3.icon = flavors[2].image
	
	$FoodRequest/RequestedFood.texture = requestedFood.image
	$FoodRequest/RequestedFlavor.texture = requestedFlavor.image
	
	
	
	
	##Make new person visible
	var tween = get_tree().create_tween()
	tween.tween_property($DivorceWoman, "modulate:a", 1, 0.8).set_trans(Tween.TRANS_EXPO)
	
	
	##Request speech bubble appears
	##TODO: This.
	tween.tween_property($FoodRequest, "modulate:a", 1, 0.8).set_trans(Tween.TRANS_EXPO)
	##Food buttons slide in
	tween.parallel().tween_property($CanvasLayer/FoodSelect/VBoxContainer, "position:x", 1052, 0.3).set_trans(Tween.TRANS_QUAD)
	
	
	



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
