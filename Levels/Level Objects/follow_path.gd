extends Path2D

@export var speed: float = 100.0

@onready var path: PathFollow2D = $PathFollow2D

func _process(delta: float) -> void:
    path.progress += speed * delta


