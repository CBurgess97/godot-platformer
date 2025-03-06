extends Node
class_name PlayerMovementComponent

@export var speed: float = 500.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 1000.0
@export var acceleration: float = 1500.0
@export var friction: float = 1000.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1

var velocity: Vector2 = Vector2.ZERO
var direction: float = 0.0

@onready var character: CharacterBody2D = get_parent()


func move_player(delta, new_direction : float) -> void:

    # Update Movement Direction
    direction = new_direction

    # Handle horizontal movement
    update_horizontal_movement(delta)

    # Handle vertical movement
    update_vertical_movement(delta)

    # Apply movement
    character.velocity = velocity
    character.move_and_slide()

func update_horizontal_movement(delta: float) -> void:
    if direction:
        velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, friction * delta)

func update_vertical_movement(delta: float) -> void:

    # Handle jumping
    if Input.is_action_just_pressed("ui_up"):
        velocity.y = jump_velocity

    # Apply gravity
    velocity.y += gravity * delta