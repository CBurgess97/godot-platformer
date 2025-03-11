extends TileMapLayer
class_name Level

@export var level_name: String = ""
@export_file var level_path: String = ""
@export var player : Player = null

@onready var level_manager: LevelManager = null


var objects: Array[LevelObject] = []

func _ready() -> void:
	for child in get_children():
		if child is LevelObject:
			objects.append(child)

func enter_level() -> void:
	level_manager = get_parent()
	for object in objects:
		object.enter_level()
	pass

func exit_level() -> void:
	for object in objects:
		object.exit_level()
	pass
