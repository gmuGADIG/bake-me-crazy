class_name ItemData extends Resource

#Name of the item
@export var name: String
@export var desription:String
#If an item has no quality attribute use a negative integer
@export var quality: int = -1
#AtlasTexture??
@export var icon: Texture2D
#Price of the item for buying
@export var price: int = 0


###TODO: If the item is bakable add a recipe: @export var recipe: Recipe
