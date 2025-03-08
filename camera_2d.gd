extends Camera2D

@export var player: Node2D = null

func _process(_delta: float) -> void:
    if player != null:
        position = player.position
        pass