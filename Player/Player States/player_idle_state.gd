extends PlayerState

@onready var state_name = "idle"

func process(_delta):
	if player.level_manager != null:
		player.level_manager.camera.user_interface.reset_prompt.visible = false



func physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_jump"):
		player.movement.attempt_jump()

	player.movement.move_player(delta, Input.get_axis("ui_left", "ui_right"))
