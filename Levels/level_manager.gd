extends Node2D
class_name LevelManager


@onready var objects: Array[LevelObject] = []
@onready var current_level: Level = null

@export var player: Player = null
@export_file var starting_level: String = ""

func _ready() -> void:
	change_level(starting_level)
	pass


func change_level(level_path: String) -> void:
	if current_level != null:
		current_level.exit_level()
		current_level.queue_free()
	current_level = load(level_path).instantiate()
	current_level.level_manager = self
	add_child(current_level)
	current_level.enter_level()
	player.move_to(current_level.spawn_point.position)

	objects.clear()
