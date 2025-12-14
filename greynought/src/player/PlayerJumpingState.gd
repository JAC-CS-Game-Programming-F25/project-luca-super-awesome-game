extends State
class_name PlayerJumpingState

var jump_delay: float = 0.0
const JUMP_DELAY_TIME: float = 0.1
var jump_applied: bool = false

func enter(parameters: Dictionary = {}):
	player.play_animation(PlayerStates.JUMPING)
	player.body_sprites.pause()
	jump_delay = 0.0
	jump_applied = false

func update(delta: float):
	if not jump_applied:
		jump_delay += delta
		if jump_delay >= JUMP_DELAY_TIME:
			player.body_sprites.play(PlayerStates.JUMPING)
			player.velocity.y = player.JUMP_VELOCITY
			jump_applied = true

func physics_update(delta: float):
	player.update_facing_direction()
	
	var direction = 0
	if Input.is_action_pressed(InputKeys.MOVE_LEFT):
		direction -= 1
	if Input.is_action_pressed(InputKeys.MOVE_RIGHT):
		direction += 1
	
	if direction != 0:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED * delta)
	
	if player.is_on_floor() and jump_applied:
		if direction != 0:
			state_machine.change(PlayerStates.WALKING)
		else:
			state_machine.change(PlayerStates.IDLE)
