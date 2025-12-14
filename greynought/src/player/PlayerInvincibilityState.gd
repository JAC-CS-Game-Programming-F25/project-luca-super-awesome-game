extends State
class_name PlayerInvincibilityState

var invincibility_timer: float = 0.0
const INVINCIBILITY_DURATION: float = 2.0

func enter(parameters: Dictionary = {}):
	invincibility_timer = 0.0
	player.invincible_timer = INVINCIBILITY_DURATION
	
	if player.velocity.x != 0:
		player.play_animation(PlayerStates.WALKING)
	else:
		player.play_animation(PlayerStates.IDLE)

func update(delta: float):
	invincibility_timer += delta
	
	var flash_speed = 15.0
	player.body_sprites.modulate.a = 0.3 + 0.7 * abs(sin(invincibility_timer * flash_speed))
	
	if invincibility_timer >= INVINCIBILITY_DURATION:
		if player.is_on_floor():
			if player.velocity.x != 0:
				state_machine.change(PlayerStates.WALKING)
			else:
				state_machine.change(PlayerStates.IDLE)
		else:
			state_machine.change(PlayerStates.JUMPING)

func physics_update(delta: float):
	player.update_facing_direction()
	
	var direction = 0
	if Input.is_action_pressed(InputKeys.MOVE_LEFT):
		direction -= 1
	if Input.is_action_pressed(InputKeys.MOVE_RIGHT):
		direction += 1
	
	if direction != 0:
		player.velocity.x = direction * player.SPEED
		if player.body_sprites.animation != PlayerStates.WALKING:
			player.body_sprites.play(PlayerStates.WALKING)
	else:
		player.velocity.x = 0
		if player.body_sprites.animation != PlayerStates.IDLE:
			player.body_sprites.play(PlayerStates.IDLE)
	
	if Input.is_action_just_pressed(InputKeys.MOVE_JUMP) and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		player.body_sprites.play(PlayerStates.JUMPING)

func exit():
	player.body_sprites.modulate.a = 1.0
	player.invincible_timer = 0.0
