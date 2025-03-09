extends PlayerState
class_name PlayerDeathState

@onready var state_name = "death"

func physics_process(_delta: float) -> void:
    print("Player is dead!")