extends PlayerState
class_name PlayerDeathState

@onready var state_name = "death"

func enter():
	player.dead = true
	player.audio_manager.death_sound()
	player.level_manager.stop_music()
	player.level_manager.camera.user_interface.reset_prompt.visible = true
	player.movement.drop()

func physics_process(_delta: float) -> void:
	player.movement.move_player(_delta, 0)

	if Input.is_action_just_pressed("ui_restart"):
		player.level_manager.reload_current_level()
