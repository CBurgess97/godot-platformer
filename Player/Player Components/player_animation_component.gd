extends Node
class_name PlayerAnimationComponent

@onready var character: Player = get_parent()

var facing_right := true

func _process(_delta: float) -> void:
	update_animation()

func update_animation() -> void:
	if character.is_on_floor():
		if abs(character.velocity.x) > 10:
			character.animation.play("walk")
		else:
			character.animation.play("idle")
	else:
		if character.velocity.y < 0:
			character.animation.play("jump")
		else:
			character.animation.play("fall")
		
	if character.dead:
		character.animation.play("dead_fall")
		if character.is_on_floor():
			character.animation.play("dead")
			
	if facing_right and character.velocity.x < -10:
		facing_right = false
		character.animation.flip_h = true
	elif not facing_right and character.velocity.x > 10:
		facing_right = true
		character.animation.flip_h = false
	
	if character.animation.flip_h:
		character.animation.offset.x = 4
	else:
		character.animation.offset.x = 0
