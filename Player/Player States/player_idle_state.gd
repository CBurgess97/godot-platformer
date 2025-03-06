extends PlayerState

@onready var state_name = "idle"

func physics_process(delta: float) -> void:
	player.movement.move_player(delta, Input.get_axis("ui_left", "ui_right"))
