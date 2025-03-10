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

@export_category("Input_Buffers")
@export var jump_buffer_time: float = 0.1
@export var coyote_time: float = 0.1
@export var bounce_time: float = 0.1

@export_category("Death")
@export var on_death_bounce_amount: float = 100.0
@export var on_death_bounce_count: int = 2

# Internal State
var velocity := Vector2.ZERO
var direction: float = 0.0
var is_jumping := false
var jump_attempted := false
var coyote_jump_available := true
var dropping := false
var bounce_counter = 0

# Timer References
var input_buffer: Timer
var coyote_timer: Timer
var mandatory_jump_timer: Timer
var bounce_timer: Timer

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

	# Set up bounce timer
	bounce_timer = Timer.new()
	bounce_timer.one_shot = true
	bounce_timer.wait_time = bounce_time
	add_child(bounce_timer)

func move_player(delta: float, new_direction: float) -> void:

	if dropping:
		if character.is_on_floor() and not bounce_counter == 2:
			velocity.y = -on_death_bounce_amount
			on_death_bounce_amount *= 0.5
			velocity.x *= 0.5
			bounce_counter += 1
		elif bounce_counter == 2:
			velocity.x = 0
		velocity.y += (gravity * delta)
		character.velocity = velocity
		character.move_and_slide()
		return



	# Update the movement direction based on input
	direction = new_direction
	
	# Update horizontal and vertical velocities
	update_horizontal_velocity(delta)
	update_vertical_velocity(delta)
	
	# Reset jump attempt flag
	jump_attempted = false
	
	# Handle coyote jump logic
	if character.is_on_floor() and velocity.y >= 0:
		# Player is grounded, enable coyote jump and stop the timer
		coyote_jump_available = true
		coyote_timer.stop()
	else:
		# Player is in the air
		if coyote_jump_available and coyote_timer.is_stopped():
			# Start the coyote timer when first leaving the ground
			coyote_timer.start()
	
	# Apply the calculated velocity to the character and move
	character.velocity = velocity
	character.move_and_slide()

func update_horizontal_velocity(delta: float) -> void:
	# Determine target speed based on input direction
	var target_speed = direction * speed

	# Calculate the difference between target speed and current speed
	var speed_diff = target_speed - velocity.x

	# Select acceleration or deceleration rate based on whether we're trying to move
	var accel_rate = acceleration if abs(target_speed) > 0.01 else deceleration

	# Calculate movement adjustment using a power function for smoother transitions
	var movement = pow(abs(speed_diff) * accel_rate, velocity_power) * sign(speed_diff)

	# Apply ground friction when not moving horizontally and on the ground
	if character.is_on_floor() and direction == 0:
		var friction_amount = min(abs(velocity.x), friction)
		velocity.x -= friction_amount * sign(velocity.x)
	
	# Adjust movement speed at jump peak
	if is_at_jump_peak():
		movement *= peak_jump_speed_multiplier

	# Update horizontal velocity
	velocity.x += movement * delta

func update_vertical_velocity(delta) -> void:

	# Handle jump input and initiation
	if jump_attempted or input_buffer.time_left > 0:
		if coyote_jump_available: # If jumping on the ground
			mandatory_jump_timer.start()
			jump()
			is_jumping = true
			coyote_jump_available = false
		elif jump_attempted: # Queue input buffer if jump was attempted
			input_buffer.start()
			jump_attempted = false

	# Cut jump short when jump button is released during ascent
	if is_jumping and mandatory_jump_timer.time_left == 0 and bounce_timer.time_left == 0 and not Input.is_action_pressed("ui_jump"):
		velocity.y = max(velocity.y * (1 - jump_cut_multiplier), velocity.y)

	# Handle landing to reset jump state
	if is_jumping and velocity.y > 0 and character.is_on_floor():
		is_jumping = false
		mandatory_jump_timer.stop()
	
	# Adjust gravity based on jump state
	var current_gravity = gravity
	if is_jumping:
			if is_at_jump_peak():
				current_gravity *= jump_peak_gravity_modifier
			elif is_falling() and bounce_timer.time_left == 0:
				current_gravity *= fall_gravity_multiplier

	# Apply gravity when in air, reset downward velocity when grounded
	if not character.is_on_floor():
		velocity.y += (current_gravity * delta)
	elif velocity.y > 0:
		velocity.y = 0
	
	if character.is_on_ceiling():
		if velocity.y < 0:
			velocity.y = 0

	# Clamp maximum downward velocity
	if velocity.y > gravity_clamp:
		velocity.y = gravity_clamp

func bounce(strength: float) -> void:
	velocity.y = -strength
	bounce_timer.start()

func coyote_timeout() -> void:
	coyote_jump_available = false

func is_at_jump_peak() -> bool:
	return (is_jumping and (velocity.y > -10 and velocity.y < 10))

func jump() -> void:
	velocity.y = jump_velocity

func attempt_jump() -> void:
	jump_attempted = true

func drop() -> void:
	dropping = true
	velocity.y = 0

func is_falling() -> bool:
	return velocity.y > 0
