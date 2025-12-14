extends State
class_name WeaponInvincibilityState

var invincibility_timer: float = 0.0
const INVINCIBILITY_DURATION: float = 2.0

func enter(parameters: Dictionary = {}):
	weapon.weapon_sprite.play(WeaponStates.INVINCIBLE)
	invincibility_timer = 0.0

func update(delta: float):
	invincibility_timer += delta
	
	# Flash effect
	var flash_speed = 15.0
	weapon.weapon_sprite.modulate.a = 0.3 + 0.7 * abs(sin(invincibility_timer * flash_speed))
	
	if invincibility_timer >= INVINCIBILITY_DURATION:
		state_machine.change(WeaponStates.IDLE)

func exit():
	weapon.weapon_sprite.modulate.a = 1.0
