extends Node
class_name DamageOnContactComponent


func on_enter_hitbox(node : Node) -> void:
	if node.has_method("change_state"):
		if not node.dead:
			node.change_state("death")
	if not node.dead:
		node.movement.bounce(200)
