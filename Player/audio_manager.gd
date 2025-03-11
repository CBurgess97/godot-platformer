extends Node
class_name AudioManager

@export var jump : AudioStreamPlayer = null
@export var bounce : AudioStreamPlayer = null
@export var death : AudioStreamPlayer = null

func jump_sound() -> void:
	jump.play()

func bounce_sound() -> void:
	bounce.play()

func death_sound() -> void:
	death.play()
