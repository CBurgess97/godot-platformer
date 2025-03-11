extends Node2D

# Export variables for easy tweaking in the editor
@export var target_node: Node2D  # The node to follow
@export var trail_length: int = 20  # How many points in the trail
@export var trail_width: float = 2.0  # Width of the trail line
@export var trail_color: Color = Color.WHITE  # Color of the trail
@export var fade_duration: float = 0.5  # How long the trail takes to fade

# Internal variables
var line: Line2D
var points: Array = []  # Array to store trail points

func _ready():
	# Create and setup the Line2D node
	line = Line2D.new()
	add_child(line)
	
	# Configure line properties
	line.width = trail_width
	line.default_color = trail_color
	line.gradient = Gradient.new()
	line.gradient.set_color(0, trail_color)
	line.gradient.set_color(1, Color(trail_color.r, trail_color.g, trail_color.b, 0))
	
	# Check if target_node is assigned
	if not target_node:
		push_warning("TrailEffect: No target node assigned!")
		set_physics_process(false)

func _physics_process(_delta):
	if not target_node:
		return
		
	# Add new point at target's position
	points.push_front(target_node.global_position)
	
	# Remove excess points
	if points.size() > trail_length:
		points.pop_back()
	
	# Update line points
	line.points = PackedVector2Array(points)
	
	# Update gradient offset based on point count
	if points.size() > 1:
		var gradient = line.gradient as Gradient
		gradient.offsets = [0.0, 1.0]
		gradient.colors = [
			Color(trail_color.r, trail_color.g, trail_color.b, 1.0),
			Color(trail_color.r, trail_color.g, trail_color.b, 0.0)
		]

# Optional: Method to toggle the trail visibility
func set_trail_active(active: bool):
	set_physics_process(active)
	if not active:
		points.clear()
		line.points = PackedVector2Array()

# Optional: Method to change trail color at runtime
func set_trail_color(new_color: Color):
	trail_color = new_color
	line.default_color = trail_color
	var gradient = line.gradient as Gradient
	gradient.set_color(0, trail_color)
	gradient.set_color(1, Color(trail_color.r, trail_color.g, trail_color.b, 0))