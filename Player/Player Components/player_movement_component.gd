extends Node
class_name PlayerMovementComponent

# Movement Parameters
@export_category("Movement")
@export var speed: float = 200.0
@export var acceleration: float = 10.0
@export var deceleration: float = 10.0
@export var friction: float = 90.0
@export var velocity_power: float = 0.9

# Jump Parameters
@export_category("Jump")
@export var jump_velocity: float = -200.0
@export var gravity: float = 150.0
@export var fall_gravity_multiplier: float = 1.5
@export var jump_peak_gravity_modifier: float = 0.8
@export var jump_cut_multiplier: float = 0.5
@export var peak_jump_speed_multiplier: float = 1.2
@export var gravity_clamp: float = 300.0
@export var mandatory_jump_time: float = 0.1

@export_category("Input")
@export var jump_buffer_time: float = 0.1
@export var coyote_time: float = 0.1

# Internal State
var velocity := Vector2.ZERO
var direction: float = 0.0
var is_jumping := false
var jump_attempted := false
var coyote_jump_available := true

# Timer References
var input_buffer: Timer
var coyote_timer: Timer
var mandatory_jump_timer: Timer

@onready var character: Player = get_parent()

func _ready() -> void:
	# Set up input buffer timer
	input_buffer = Timer.new()
	input_buffer.wait_time = jump_buffer_time
	input_buffer.one_shot = true
	add_child(input_buffer)

	# Set up coyote timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

	# Set up hop timer
	mandatory_jump_timer = Timer.new()
	mandatory_jump_timer.wait_time = mandatory_jump_time
	mandatory_jump_timer.one_shot = true
	add_child(mandatory_jump_timer)

func move_player(delta, new_direction : float) -> void:
	# Update Movement Direction
	direction = new_direction
	update_horizontal_velocity(delta)
	update_vertical_velocity(delta)
	jump_attempted = false

	# Apply gravity and reset coyote timer
	if character.is_on_floor() and velocity.y >= 0:
		coyote_jump_available = true
		coyote_timer.stop()
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()

	# Apply movement
	character.velocity = velocity
	character.move_and_slide()

func update_horizontal_velocity(delta: float) -> void:
	var targetSpeed = direction * speed
	# Difference between target speed and current speed
	var speed_diff = targetSpeed - velocity.x
	var accel_rate = acceleration if abs(targetSpeed) > 0.01 else deceleration
	# Calculate movement based on the difference in speed and acceleration rate
	var movement = pow(abs(speed_diff) * accel_rate, velocity_power) * sign(speed_diff) 

	# Apply ground friction
	if character.is_on_floor() and direction == 0:
		var amount = min(abs(velocity.x), abs(friction))
		amount *= sign(velocity.x)
		velocity.x += -amount
	
	if is_at_jump_peak():
		movement *= peak_jump_speed_multiplier

	velocity.x += movement * delta

func update_vertical_velocity(delta) -> void:

	var current_gravity = gravity

	if jump_attempted or input_buffer.time_left > 0:
		if coyote_jump_available: # If jumping on the ground
			mandatory_jump_timer.start()
			jump()
			is_jumping = true
			coyote_jump_available = false
		elif jump_attempted: # Queue input buffer if jump was attempted
			input_buffer.start()

	# Cut jump short if jump button is released
	if is_jumping and mandatory_jump_timer.time_left == 0 and not Input.is_action_pressed("ui_jump"):
		velocity.y = max(velocity.y * (1 - jump_cut_multiplier), velocity.y)

	if is_jumping and velocity.y > 0 and character.is_on_floor():
		is_jumping = false
		mandatory_jump_timer.stop()

	if is_jumping and velocity.y > 0:
		velocity.y = velocity.y * fall_gravity_multiplier
	
	if is_at_jump_peak():
		current_gravity *= jump_peak_gravity_modifier

	if not character.is_on_floor():
		velocity.y += (current_gravity * delta)
	elif velocity.y > 0:
		velocity.y = 0

	if velocity.y > gravity_clamp:
		velocity.y = gravity_clamp
	

func coyote_timeout() -> void:
	coyote_jump_available = false

func is_at_jump_peak() -> bool:
	return (is_jumping and (velocity.y > -10 and velocity.y < 10))

func jump() -> void:
	velocity.y = jump_velocity

func attempt_jump() -> void:
	jump_attempted = true
