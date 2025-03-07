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

var coyote_timer : Timer # Reference to the coyote timer
var coyote_jump_available := true


@onready var character: CharacterBody2D = get_parent()

func _ready() -> void:
    # Set up coyote timer
    coyote_timer = Timer.new()
    coyote_timer.wait_time = coyote_time
    coyote_timer.one_shot = true
    add_child(coyote_timer)
    coyote_timer.timeout.connect(coyote_timeout)

func move_player(delta, new_direction : float) -> void:

    # Update Movement Direction
    direction = new_direction

    update_horizontal_movement(delta)

    if Input.is_action_just_pressed("ui_up"):
        try_jump()

    # Apply gravity and reset coyote timer
    if character.is_on_floor():
        coyote_jump_available = true
        coyote_timer.stop()
    else:
        if coyote_jump_available:
            if coyote_timer.is_stopped():
                coyote_timer.start()
        apply_gravity(delta)

    # Apply movement
    character.velocity = velocity
    character.move_and_slide()

func update_horizontal_movement(delta: float) -> void:
    if direction:
        velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_gravity(delta: float) -> void:
    # Apply gravity
    velocity.y += gravity * delta

func try_jump() -> void:
    if coyote_jump_available:
        velocity.y = jump_velocity

func coyote_timeout() -> void:
    coyote_jump_available = false