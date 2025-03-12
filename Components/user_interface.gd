extends Control
class_name UserInterface


@export var level_name_label: Label = null
@export var time_label: Label = null
@export var level_manager : LevelManager = null
@export var reset_prompt : Label = null

var level_name: String = ""
var time_elapsed: float = 0
var timeer_stopped: bool = false

func initialize():
	level_name_label.text = level_manager.get_level_name()
	level_manager.connect("level_changed", _on_level_changed)

func _process(delta):
	if timeer_stopped:
		return
	time_elapsed += delta
	var minutes = floor((time_elapsed / 60))
	var seconds = time_elapsed - (minutes * 60)
	minutes = str(minutes).pad_decimals(0)
	seconds = str(seconds).pad_decimals(0)

	if seconds.length() == 1:
		seconds = "0" + seconds
	if minutes.length() == 1:
		minutes = "0" + minutes
	time_label.text = str(minutes).pad_decimals(0) + ":" + str(seconds).pad_decimals(0)

func _on_level_changed(level_name: String):
	self.level_name = level_name
	level_name_label.text = level_name
