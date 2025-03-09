extends Camera2D

@export var target: Node2D = null
@export var damping: float = 5.0  # How quickly the camera catches up (higher = faster)

# Internal variables
var player: Node2D  # Reference to the player node

func _ready():
	# Check if target is assigned
	if not target:
		push_warning("Camera2D: No target node assigned!")

func _physics_process(delta):
	position = position.lerp(target.position, damping * delta)
