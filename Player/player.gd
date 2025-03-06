extends CharacterBody2D
class_name Player

@onready var movement: PlayerMovementComponent = $PlayerMovementComponent
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine