@tool
extends Control
class_name DayCycle

@onready var sun        := $SunMoon/Sun
@onready var moon       := $SunMoon/Moon
@onready var skyline    := $Skyline
@onready var background := $Background
@onready var circle     := $Calendar/Circle

const CIRCLE_BASE_POS = Vector2(-546.383, -207.086)
const CIRCLE_STRIDE_X = (441.107 - (-546.383)) / 6.0
const CIRCLE_STRIDE_Y = (218.617 - (-207.086)) / 3.0

func _ready() -> void:
	circle.position = CIRCLE_BASE_POS
	
	# The day is 1-indexed, so we subtract 1 to get a 0-indexed value.
	var circle_index = PlayerData.data.day - 1
	
	# Compute circle position based on 0 indexed value.
	while circle_index >= 7:
		circle.position.y += CIRCLE_STRIDE_Y
		circle_index -= 7
	circle.position.x += CIRCLE_STRIDE_X * circle_index
	
	MainMusicPlayer.transition_to_song(preload("res://menus/day_cycle/day_night_cycle.tres"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sun.global_rotation = 0
	moon.global_rotation = 0
	
	var color: Color = background.color
	color.s -= 0.3
	skyline.modulate = color

func _anim_change_scene() -> void:
	var scene: PackedScene
	if PlayerData.data.day >= 14:
		scene = preload("res://dialogue/narration/festival_player.tscn")
	else:
		scene = preload("res://free_roam/world/farmers_market/farmers_market.tscn")
	
	SceneTransition.change_scene_to_packed(scene)
