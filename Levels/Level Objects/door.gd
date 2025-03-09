extends LevelObject
class_name Door

@export_file var target_scene : String

@onready var stage_transition : LevelObjectComponent = $InteractArea

func _ready() -> void:
	stage_transition.target_scene = target_scene


func interact():
	level.level_manager.change_level(target_scene)
