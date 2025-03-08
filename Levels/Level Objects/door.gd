extends LevelObject
class_name Door

@export_file var target_scene : String

func interact():
    level.level_manager.change_level(target_scene)
