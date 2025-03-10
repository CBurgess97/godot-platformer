extends Node

@export var hitbox : Area2D = null
@export var stomp_box : Area2D = null
@export var bounce_force : float = 200


func _ready() -> void:
	hitbox.connect("body_entered", _on_hitbox_body_entered)
	stomp_box.connect("body_entered", _on_stomp_box_body_entered)

func _on_hitbox_body_entered(body : Node) -> void:
	if body.has_method("change_state"):
		body.change_state("death")
	pass

func _on_stomp_box_body_entered(body : Node) -> void:
	if body.is_in_group("player"):
		if body.movement.is_falling() and not body.dead:
			body.movement.bounce(bounce_force)
			if get_parent().has_method("death"):
				get_parent().death()
				queue_free()
		else:
			body.change_state("death")
	pass
