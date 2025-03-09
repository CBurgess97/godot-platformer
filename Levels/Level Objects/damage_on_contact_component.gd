extends LevelObjectComponent
class_name DamageOnContactComponent


func on_enter_hitbox(node : Node) -> void:
	if node.has_method("take_damage"):
		node.take_damage()
