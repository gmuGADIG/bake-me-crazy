extends CanvasLayer

@onready var anim: AnimationPlayer = %Anim

@onready var portraits := [
	%Callum, %Millie, %Raymond, %Pepper
]

@onready var codename_lut := {
	"pepper": %Pepper,
	"spicy": %Pepper,
	
	"callum": %Callum,
	"salty": %Callum,
	
	"millie": %Millie,
	"savory": %Millie,
	"umami": %Millie,
	
	"raymond": %Raymond,
	"sweet": %Raymond,
}

func request_heart_animation(codename: String) -> void:
	print("[heart_gain_indicator] request_heart_animation")
	if codename not in codename_lut:
		# panic!
		push_error("unknown codename " + codename)
		return
	if anim.is_playing():
		# panic again!
		push_warning("heart gain animation already playing? ignoring!")
		return
	
	for p in portraits:
		p.hide()
	codename_lut[codename].show()
	anim.play("new_animation")

func _ready() -> void:
	Relationships.heart_gained.connect(request_heart_animation)
