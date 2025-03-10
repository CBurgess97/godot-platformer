extends Control


@export var level_name_label: Label = null
@export var level_manager : LevelManager = null

var level_name: String = ""

func _ready():
	level_manager.connect("level_changed", _on_level_changed)
	level_name_label.text = level_manager.get_level_name()

func _on_level_changed(level_name: String):
	self.level_name = level_name
	level_name_label.text = level_name
