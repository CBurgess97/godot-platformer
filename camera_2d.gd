extends Camera2D

@export var target: Node2D = null
@export var track_vertical: bool = false
@export var track_horizontal: bool = true
@export var vertical_offset: float = -40.0
@export var camera_horizontal_offset: float = 3.0
@export var damping: float = 5.0  # How quickly the camera catches up (higher = faster)

var real_position: Vector2 = Vector2()

# Internal variables
var player: Node2D  # Reference to the player node

func _ready():
	# Check if target is assigned
	if not target:
		push_warning("Camera2D: No target node assigned!")

func _physics_process(delta):
	if track_vertical:
		real_position.y = lerp(position.y, target.position.y, damping * delta)

	if track_horizontal:
		real_position.x = lerp(position.x, target.position.x, damping * delta) + camera_horizontal_offset
	
	
	# snap position to whole values
	position = real_position.round()
	position.y += vertical_offset
