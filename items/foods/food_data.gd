class_name FoodData extends ItemData

enum FoodType {
	NULL, ##Default value that shouldn't be used
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
	SWEET_ROLL
}

@export var cooking_minigame: PackedScene
@export var food_type : FoodType

## The ingredient used. Determines the cost to make, and the flavor profile.
## May be null for no key ingredient (e.g. sourdough bread, plain cake, etc.)
@export var ingredient: IngredientData
