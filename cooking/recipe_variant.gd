class_name RecipeVariant extends Resource

@export var texture: Texture2D = null

## The ItemData that we require for this recipe.
## 
## Note that ItemData are compared by reference.
@export var key_ingredient: ItemData = null
@export var key_ingredient_requirement: int = 0

## The parent Recipe associated with this variant.
##
## WARNING: this is NOT SET until the recipe variant is selected through the
## recipe book!
@export var parent: Recipe = null

@export var name: String
