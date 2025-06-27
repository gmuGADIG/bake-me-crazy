extends Node
## Manages 2 things:
## 1. Helper functions for showing other UIs for Dialogic, such as open_market
##    to open a market UI.
## 2. Manages the "mid_interaction" variable / function. This allows other scripts
##    to determine whether we are currently "mid interaction," in which case
##    they should suspend their behavior.
class_name DialogueManagerScript

var _current_market_ui: MarketUI = null
var _current_recipe_pop_up: NewRecipePopUp = null

func is_mid_interaction() -> bool:
	if Dialogic.current_timeline != null: return true
	if _current_market_ui != null: return true
	if _current_recipe_pop_up != null: return true
	
	return false

func open_market(market) -> void:
	if _current_market_ui != null:
		# If a market_ui already exists, don't do anything.
		# Note that the UI should automatically become invalid if we load
		# into a different scene.
		return
	
	if market is not String:
		push_error("When calling open_market, specify a market_ui.tscn path.")
		return
	var market_scene = load(market)
	if !market_scene:
		push_error("Incorrect market scene path. Be sure the path is correct.")
		return
	if market_scene is not PackedScene:
		push_error("Incorrect market scene path. Be sure the path is correct.")
		return
	var the_market = market_scene.instantiate()
	if the_market is not MarketUI:
		push_error("Market UI should be an instance of MarketUI, otherwise the code will break.")
		push_error("If we've added a market UI that shouldn't be a MarketUI, please make the relevant")
		push_error("code chnages so it'll work.")
		return
	
	# Add the market ui as a child of the current scene.
	get_tree().current_scene.add_child(the_market)
	
	_current_market_ui = the_market

func has_any_new_recipe() -> bool:
	return PlayerData.data.queued_recipe_unlocks.size() > 0

func has_new_recipe(recipe_path: String) -> bool:
	return PlayerData.data.queued_recipe_unlocks.has(recipe_path)

func unlock_new_recipe(recipe_path: String) -> void:
	Dialogic.Styles.get_layout_node().visible = false
	Dialogic.paused = true
	
	# move the recipe from queued_recipe_unlocks to unlocked_recipe_paths
	var idx = PlayerData.data.queued_recipe_unlocks.find(recipe_path)
	assert(idx != -1, "Can't unlock recipe '%s' as it wasn't in the unlock queue!" % recipe_path)
	
	PlayerData.data.queued_recipe_unlocks.remove_at(idx)
	PlayerData.data.unlocked_recipe_paths.append(recipe_path)
	
	# show pop-up telling the player about the new recipe
	var recipe = load(recipe_path) as FoodGroup
	var pop_up = preload("res://menus/new_recipe_pop_up/new_recipe_pop_up.tscn").instantiate()
	get_tree().current_scene.add_child(pop_up)
	pop_up.set_recipe(recipe)
	_current_recipe_pop_up = pop_up
	
	await pop_up.tree_exiting
	Dialogic.paused = false
	Dialogic.Styles.get_layout_node().visible = true

func change_scene(scene_path: String) -> void:
	SceneTransition.change_scene_to_file(scene_path)
