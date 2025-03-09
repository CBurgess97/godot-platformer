extends Camera2D

@export var target: Node2D = null
@export var track_vertical: bool = false
@export var track_horizontal: bool = true
@export var camera_horizontal_offset: float = 3.0
@export var damping: float = 5.0  # How quickly the camera catches up (higher = faster)

# Internal variables
var player: Node2D  # Reference to the player node

func _ready():
	# Check if target is assigned
	if not target:
		push_warning("Camera2D: No target node assigned!")

func _physics_process(delta):
	if track_vertical:
		position.y = lerp(position.y, target.position.y, damping * delta)

	if track_horizontal:
		position.x = lerp(position.x, target.position.x, damping * delta) + camera_horizontal_offset
