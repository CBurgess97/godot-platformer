extends Node2D
class_name LevelManager

@onready var objects: Array[LevelObject] = []

func _ready() -> void:
    for child in get_children():
        if child is LevelObject:
            objects.append(child)
            child.init()

