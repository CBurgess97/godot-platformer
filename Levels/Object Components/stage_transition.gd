extends LevelObjectComponent

@export_file var target_scene : String

@onready var level : Level = null

func interact():
    level.level_manager.change_level(target_scene)
