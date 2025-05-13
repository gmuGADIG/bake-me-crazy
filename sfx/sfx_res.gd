extends Resource
class_name SoundEffect

@export var interrupt: bool = true
@export var sound_file: AudioStream
# if true, automatically loop after completion
@export var looping: bool = false

# if 0, doesn't expire. If > 0, the sound will stop after the elapsed time.
# NOTE: In the SFXPlayer, if a sound is played with interrupt off and that
# effect is already playing, then it will reset the exipration timer. 
# Essentially, playing the sound effect acts as a refresh for this sound's
# lifetime.
@export var expiration_time: float = 0.0
