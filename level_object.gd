extends Node
class_name LevelObject

@onready var area = $Area2D

func _ready():
	add_to_group("level_object")
	pass

func init():
	pass
