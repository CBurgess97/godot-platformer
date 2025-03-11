extends AudioStreamPlayer
class_name MusicManager

func _ready() -> void:
    play()
    pass

func stop_music() -> void:
    stop()
    pass

func reset_music() -> void:
    stop()
    play()
    pass