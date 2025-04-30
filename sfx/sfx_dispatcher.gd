extends Node

# Import the custom resource
const EventSFXMapping = preload("res://sfx/event_sfx_mapping.gd")

# Export an array of these mappings that can be configured in the Inspector
@export var event_sfx_mappings: Array[EventSFXMapping] = []

func _ready():
	# Setup the mappings at runtime
	if event_sfx_mappings.size() > 0:
		# Connect to node_added to catch new nodes
		get_tree().node_added.connect(_on_node_added)
		
		# Process existing nodes
		_process_existing_nodes(get_tree().root)

func _process_existing_nodes(node):
	_try_connect_node(node)
	
	# Recursively process all children
	for child in node.get_children():
		_process_existing_nodes(child)

func _on_node_added(node):
	_try_connect_node(node)

func _try_connect_node(node):
	# Check each mapping to see if this node should have events connected
	for mapping in event_sfx_mappings:
		# Check if node type matches our mapping
		var type_name = node.get_class()
		if type_name == mapping.node_type:
			# Connect to the specified event if it exists
			if node.has_signal(mapping.event_name):
				# Avoid duplicate connections
				if not node.is_connected(mapping.event_name, _on_event_triggered.bind(mapping.sfx_id)):
					node.connect(mapping.event_name, _on_event_triggered.bind(mapping.sfx_id))

func _on_event_triggered(sfx_id: String):
	# Play the associated sound effect using the autoloaded SFX player
	MainSFXPlayer.play_from_id(sfx_id)
