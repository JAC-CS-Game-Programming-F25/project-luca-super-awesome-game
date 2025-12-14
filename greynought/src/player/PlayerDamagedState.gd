extends State
class_name PlayerDamagedState

var damage_timer: float = 0.0
const DAMAGE_DURATION: float = 0.5
const KNOCKBACK_FORCE: float = 200.0

func enter(parameters: Dictionary = {}):
	player.play_animation(PlayerStates.DAMAGED)
	damage_timer = 0.0
	
	var damage_direction = parameters.get("direction", -1)
	player.velocity.x = damage_direction * KNOCKBACK_FORCE
	player.velocity.y = -150

func update(delta: float):
	damage_timer += delta
	
	if damage_timer >= DAMAGE_DURATION:
		state_machine.change(PlayerStates.INVINCIBLE)

func exit():
	player.body_sprites.modulate.a = 1.0
