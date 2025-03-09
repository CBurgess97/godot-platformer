extends CharacterBody2D
class_name Player

@onready var movement: PlayerMovementComponent = $PlayerMovementComponent
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var hitbox : Area2D = $HitboxArea

func _ready() -> void:
	add_to_group("player")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		var areas = interaction_area.get_overlapping_areas()
		for area in areas:
			if area.get_parent().has_method("interact"):
				area.get_parent().interact()
				return
	
	var hitbox_areas = hitbox.get_overlapping_areas()
	for area in hitbox_areas:
		if area.has_method("on_enter_hitbox"):
			area.on_enter_hitbox(self)

func move_to(_position: Vector2) -> void:
	position = _position


func take_damage() -> void:
	print("Ouch!")

func change_state(state : String) -> bool:
	var success = state_machine.set_state(state)
	return success