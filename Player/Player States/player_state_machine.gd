extends Node
class_name PlayerStateMachine

@export var starting_state: PlayerState = null

@onready var player: Player = get_parent()
@onready var current_state: PlayerState = null
@onready var state_dictionary: Dictionary[String, PlayerState] = {}

func _ready():

	# Initialize all states and add them to the state dictionary
	for state in get_children():
		if state is PlayerState:
			state.init(player)
			state_dictionary[state.state_name] = state

	set_state(starting_state)

func set_state(state: PlayerState):
	if current_state != null:
		current_state.exit()
	current_state = state
	current_state.enter()

func _physics_process(_delta):
	if current_state != null:
		current_state.physics_process(_delta)

func _process(_delta):
	if current_state != null:
		current_state.process(_delta)

func _input(event):
	if current_state != null:
		current_state.input(event)
