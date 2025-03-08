extends CharacterBody2D
class_name Player

@onready var movement: PlayerMovementComponent = $PlayerMovementComponent
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $Area2D

func _ready() -> void:
	add_to_group("player")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		var areas = interaction_area.get_overlapping_areas()
		for area in areas:
			if area.get_parent().is_in_group("level_object") and area.get_parent().has_method("interact"):
				area.get_parent().interact()
				return

func move_to(_position: Vector2) -> void:
	position = _position
