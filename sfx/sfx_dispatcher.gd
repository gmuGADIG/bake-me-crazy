extends Node

# Import the custom resources
const EventSFXMapping = preload("res://sfx/event_sfx_mapping.gd")
const AnimationSFXMapping = preload("res://sfx/animation_sfx_mapping.gd")

# Export arrays of mappings that can be configured in the Inspector
@export var event_sfx_mappings: Array[EventSFXMapping] = []
@export var animation_sfx_mappings: Array[AnimationSFXMapping] = []

# Track connected animation players to avoid duplicates
var _connected_animation_players = {}

func _ready():
	# Sort mappings by specificity
	_sort_mappings_by_specificity()
	
	# Setup the mappings at runtime
	if event_sfx_mappings.size() > 0 or animation_sfx_mappings.size() > 0:
		# Connect to node_added to catch new nodes
		get_tree().node_added.connect(_on_node_added)
		
		# Process existing nodes
		_process_existing_nodes(get_tree().root)
		
func _sort_mappings_by_specificity():
	# Sort the event mappings from most specific to least specific
	event_sfx_mappings.sort_custom(func(a, b):
		# Name + group is most specific
		if a.node_name != "" and a.node_group != "" and (b.node_name == "" or b.node_group == ""):
			return true
		elif b.node_name != "" and b.node_group != "" and (a.node_name == "" or a.node_group == ""):
			return false
			
		# Name only is next most specific
		if a.node_name != "" and b.node_name == "":
			return true
		elif a.node_name == "" and b.node_name != "":
			return false
			
		# Group only is next most specific
		if a.node_group != "" and b.node_group == "":
			return true
		elif a.node_group == "" and b.node_group != "":
			return false
			
		# If both have the same specificity, consider them equal
		return false
	)
	
	# Sort the animation mappings from most specific to least specific
	animation_sfx_mappings.sort_custom(func(a, b):
		# Name + group is most specific
		if a.node_name != "" and a.player_group != "" and (b.node_name == "" or b.player_group == ""):
			return true
		elif b.node_name != "" and b.player_group != "" and (a.node_name == "" or a.player_group == ""):
			return false
			
		# Name only is next most specific
		if a.node_name != "" and b.node_name == "":
			return true
		elif a.node_name == "" and b.node_name != "":
			return false
			
		# Group only is next most specific
		if a.player_group != "" and b.player_group == "":
			return true
		elif a.player_group == "" and b.player_group != "":
			return false
			
		# If both have the same specificity, consider them equal
		return false
	)

func _process_existing_nodes(node):
	_try_connect_node(node)
	
	# Recursively process all children
	for child in node.get_children():
		_process_existing_nodes(child)

func _on_node_added(node):
	_try_connect_node(node)

func _try_connect_node(node):
	# Check each event mapping to see if this node should have events connected
	for mapping in event_sfx_mappings:
		# Check if node type matches our mapping
		var type_name = node.get_class()
		if type_name == mapping.node_type:
			# Check if name filter is applied and matches
			if mapping.node_name != "" and mapping.node_name != node.name:
				continue
				
			# Check if group filter is applied and matches
			if mapping.node_group != "" and not node.is_in_group(mapping.node_group):
				continue
				
			# Connect to the specified event if it exists
			if node.has_signal(mapping.event_name):
				if not node.is_connected(mapping.event_name, _on_event_triggered.bind(mapping.sfx_id, mapping.stop_sfx)):
					node.connect(mapping.event_name, _on_event_triggered.bind(mapping.sfx_id, mapping.stop_sfx))
	
	# Connect animation players for animation SFX mappings
	if node is AnimationPlayer and animation_sfx_mappings.size() > 0:
		_try_connect_animation_player(node)

func _try_connect_animation_player(player: AnimationPlayer):
	# Skip if we've already connected this player
	if player in _connected_animation_players:
		return
		
	# Check if any animation mapping applies to this player
	var should_connect = false
	for mapping in animation_sfx_mappings:
		# Check if the mapping applies based on node name and/or group
		var name_match = mapping.node_name == "" or mapping.node_name == player.name
		var group_match = mapping.player_group == "" or player.is_in_group(mapping.player_group)
		
		if name_match and group_match:
			should_connect = true
			break
			
	if should_connect:
		# Connect to animation started signal
		if not player.is_connected("animation_started", _on_animation_started):
			player.connect("animation_started", _on_animation_started.bind(player))
			_connected_animation_players[player] = true

func _on_animation_started(anim_name: String, player: AnimationPlayer):
	# Find matching animation mapping
	for mapping in animation_sfx_mappings:
		# Check if this mapping applies to the player by name
		if mapping.node_name != "" and mapping.node_name != player.name:
			continue
			
		# Check if this mapping applies to the player by group
		if mapping.player_group != "" and not player.is_in_group(mapping.player_group):
			continue
			
		# Check if animation name matches
		if mapping.animation_name == anim_name:
			MainSFXPlayer.play_from_id(mapping.sfx_id)
			
			# Continue checking - we might have both a play and stop mapping for the same animation
			# Don't return early

func _on_event_triggered(sfx_id: String, stop_sfx: bool = false):
	# Either play or stop the associated sound effect using the autoloaded SFX player
	if stop_sfx:
		MainSFXPlayer.stop_by_id(sfx_id)
	else:
		MainSFXPlayer.play_from_id(sfx_id)
