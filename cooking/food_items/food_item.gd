extends Resource
class_name FoodItem


enum Type {
	CAKE,
	CROISSANT,
	CANNELLE,
	PUFF_ROLL,
	SCONE,
	TART,
	COOKIE,
	BREAD,
	BAR,
	BROWNIE,
	MARACON,
	SWEET_ROLL,
	
	PESTO,
	BLUEBERRY_SAUCE,
	KETCHUP
}

@export var type : Type
@export var display_name : String
@export var image : Texture2D
