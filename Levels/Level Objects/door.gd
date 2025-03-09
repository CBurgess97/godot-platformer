extends LevelObject
class_name Door

@export_file var target_scene : String

@onready var interact_area : Node = $InteractArea

func _ready() -> void:
	pass


func interact():
	level.level_manager.change_level(target_scene)
