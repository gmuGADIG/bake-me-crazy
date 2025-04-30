class_name FoodData extends ItemData

@export var cooking_minigame: PackedScene

## The ingredient used. Determines the cost to make, and the flavor profile.
## May be null for no key ingredient (e.g. sourdough bread, plain cake, etc.)
@export var ingredient: IngredientData
