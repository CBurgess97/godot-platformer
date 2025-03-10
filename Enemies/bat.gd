extends Node2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D

var dead : bool = false
var death_timer : Timer
var death_time : float = 0.4

func _ready() -> void:
	animation.play("fly")
	death_timer = Timer.new()
	add_child(death_timer)
	death_timer.one_shot = true
	death_timer.wait_time = death_time

func _process(_delta: float) -> void:
	if dead and death_timer.time_left == 0:
		queue_free()

func death() -> void:
	death_timer.start()
	animation.play("stomp")
	dead = true

	pass
