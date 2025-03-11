extends Node2D

var simultaneous_scene = preload("uid://d0apchpk7yk1g").instantiate()

func _process(_delta):
	if Input.is_action_just_pressed("ui_start"):
		change_scene()

func change_scene() -> void:
	get_tree().root.add_child(simultaneous_scene)
	queue_free()
