class_name IngredientData extends ItemData

enum IngredientType {
	CHEESE,
	CHERRY,
	CHOCOLATE,
	CINNAMON,
	LEMON,
	ORANGE,
	PEANUT_BUTTER,
	PISTASCHIO,
	PORK,
	STRAWBERRY,
	TEA,
	VANILLA
}

@export var ingredient_type : IngredientType
## Short description displayed in the shop
@export var description: String
