extends LevelObjectComponent
class_name DamageOnContactComponent


func on_enter_hitbox(node : Node) -> void:
	if node.has_method("change_state"):
		node.change_state("death")
