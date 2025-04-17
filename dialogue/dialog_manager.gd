extends Node
## Manages 2 things:
## 1. Helper functions for showing other UIs for Dialogic, such as open_market
##    to open a market UI.
## 2. Manages the "mid_interaction" variable / function. This allows other scripts
##    to determine whether we are currently "mid interaction," in which case
##    they should suspend their behavior.
class_name DialogManagerScript

var _current_market_ui: MarketUI = null

func is_mid_interaction() -> bool:
	# If there is currently a timeline, we are mid interaction.
	# (this was the original condition before it was refactored into this script).
	if Dialogic.current_timeline != null:
		return true
	# If there is currently a market UI, we are mid interaction.
	if _current_market_ui != null:
		return true
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
