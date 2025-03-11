extends Node

@export var hitbox : Area2D = null
@export var stomp_box : Area2D = null
@export var bounce_force : float = 200
@export var enemy : Node2D = null


func _ready() -> void:
	stomp_box.connect("body_entered", _on_stomp_box_body_entered)

func _on_stomp_box_body_entered(body : Node) -> void:
	if body.is_in_group("player"):
		if body.movement.is_falling() and not body.dead:
			body.movement.bounce(bounce_force)
			if enemy.has_method("death"):
				enemy.death()
		else:
			body.change_state("death")
	pass
