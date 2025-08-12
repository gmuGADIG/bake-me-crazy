class_name PageVariantList
extends VBoxContainer

func set_variants(variants: Array[FoodData]) -> void:
	visible = true
	for i in range(1, get_child_count()): # start at 1 to ignore the header child
		var variant_display: PageVariant = get_child(i)
		if i > variants.size(): variant_display.hide()
		else:
			variant_display.show()
			variant_display.set_variant(variants[i-1])
