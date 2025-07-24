extends FoodStep

var containers: Array[SinglePourer] = []

var score: float = 0.0
var _sent_signal: bool = false

@onready var bowl = %Bowl

## Set this to TartContainer.png or Bar_Container.png
@export var container_texture: Texture2D = preload("res://cooking/steps/pour_step/TartContainer.png")

@export var pour_rate_multiplier := 1.0

func pre_animation():
	# Before the animation, be sure to reset all the containers again, so they
	# appear properly (?)
	for container in containers:
		container.set_container_texture(container_texture)
	
func start():
	print("Start called!")
	# Enable the bowl in start() so that it isn't moving around at the end
	# of the previous step
	bowl.enable_movement = true
	bowl.show()

func _ready() -> void:
	# Collect all the child containers
	for child in get_children():
		if child is SinglePourer:
			containers.append(child)
	
	for container in containers:
		container.set_container_texture(container_texture)
		container.pour_rate_multiplier = pour_rate_multiplier

func _process(delta: float) -> void:
	var done = true
	score = 0.0
	for container in containers:
		if not container.done:
			done = false
		score += container.score
	score /= containers.size()
	score = clamp(score, 1.0, 3.999)
	if done and not bowl.spawn_particles:
		# If there are any pour particles left, we're not done.
		if get_tree().get_node_count_in_group("PourParticle") > 0:
			return
			
		if not _sent_signal:
			finished.emit(score)
			_sent_signal = true
