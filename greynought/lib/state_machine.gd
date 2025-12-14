extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state: State

func add(state_name: String, state: State):
	state.name = state_name
	state.state_machine = self
	
	# Set appropriate reference based on owner type
	if owner is CharacterBody2D:
		state.player = owner
	else:
		state.weapon = owner  # ← Add this to handle weapon
	
	states[state_name] = state
	add_child(state)

func change(state_name: String, enter_parameters: Dictionary = {}):
	if current_state:
		current_state.exit()
	
	current_state = states[state_name]
	current_state.enter(enter_parameters)

func update(delta: float):
	if current_state:
		current_state.update(delta)

func physics_update(delta: float):
	if current_state:
		current_state.physics_update(delta)
