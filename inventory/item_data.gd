class_name ItemData extends Resource

## Name used in code, e.g. "cake_chocolate"
@export var code_name: String

## Name displayed to the user, e.g. "Chocolate Cake"
@export var display_name: String

## Description of the item displayed to the user. Not rich text at the moment.
@export var description: String

## The quality tier, or 0 if quality tiers aren't applicable
@export var quality: int = 0

## Food sprite
@export var icon: Texture2D

## Price of the item for buying
@export var price: int = 0
