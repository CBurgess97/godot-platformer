extends PlayerState
class_name PlayerDeathState

@onready var state_name = "death"

func enter():
	player.dead = true
	player.movement.drop()

func physics_process(_delta: float) -> void:
	player.movement.move_player(_delta, 0)
	print("Player is dead!")
