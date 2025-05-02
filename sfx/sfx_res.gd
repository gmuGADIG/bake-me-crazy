extends Resource
class_name SoundEffect

@export var interrupt: bool = true
@export var sound_file: AudioStream
# if true, automatically loop
@export var looping: bool = false
# if 0, doesn't expire.
@export var expiration_time: float = 0.0
