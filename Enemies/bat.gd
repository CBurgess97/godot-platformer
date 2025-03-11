extends Node2D

@export var animation : AnimatedSprite2D = null
@export var anim_player : AnimationPlayer = null

@export var delete_on_death : Node = null
@export var hover : float = 0

@export var death_sound : AudioStreamPlayer = null

@export var bat : Node2D = null

var dead : bool = false
var death_timer : Timer
var death_time : float = 0.4

func _ready() -> void:
	death_timer = Timer.new()
	add_child(death_timer)
	death_timer.one_shot = true
	death_timer.wait_time = death_time

func _process(_delta: float) -> void:
	if dead and death_timer.time_left == 0:
		queue_free()

func _physics_process(_delta: float) -> void:
	bat.position.y = hover
	bat.position = round(bat.position)

func death() -> void:
	death_timer.start()
	animation.play("stomp")
	if death_sound != null:
		death_sound.play()
	dead = true
	if delete_on_death != null:
		delete_on_death.queue_free()
