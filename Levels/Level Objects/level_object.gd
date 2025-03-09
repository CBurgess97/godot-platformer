extends Node
class_name LevelObject

@onready var level : Level = get_parent()

func _ready():
	add_to_group("level_object")
	pass

func enter_level():
	pass

func exit_level():
	pass
