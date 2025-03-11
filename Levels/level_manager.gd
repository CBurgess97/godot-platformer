extends Node2D
class_name LevelManager


@onready var objects: Array[LevelObject] = []
@onready var current_level: Level = null

@export var camera: Camera2D = null
@export_file var starting_level: String = ""
@export var music_manager: MusicManager = null

signal level_changed(level_name: String)

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
	level_changed.emit(current_level.level_name)
	camera.target = current_level.player
	current_level.player.level_manager = self

	objects.clear()

func get_level_name() -> String:
	return current_level.level_name

func reload_current_level():
	change_level(current_level.level_path)
	music_manager.reset_music()
	pass

func stop_music():
	music_manager.stop_music()
	pass
