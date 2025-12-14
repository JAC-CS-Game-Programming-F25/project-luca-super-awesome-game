extends State
class_name PlayerIdleState

func enter(parameters: Dictionary = {}):
	player.play_animation(PlayerStates.IDLE)
	player.velocity.x = 0

func physics_update(delta: float):
	player.update_facing_direction()
	
	var direction = 0
	if Input.is_action_pressed(InputKeys.MOVE_LEFT):
		direction -= 1
	if Input.is_action_pressed(InputKeys.MOVE_RIGHT):
		direction += 1
	
	if direction != 0:
		state_machine.change(PlayerStates.WALKING)
	
	if Input.is_action_just_pressed(InputKeys.MOVE_JUMP) and player.is_on_floor():
		state_machine.change(PlayerStates.JUMPING)
	
	if Input.is_action_just_pressed(InputKeys.MOVE_USE):
		state_machine.change(PlayerStates.USEITEM)
