extends State
class_name WeaponCooldownState

func enter(parameters: Dictionary = {}):
	weapon.weapon_sprite.play(WeaponStates.COOLDOWN)
	weapon.cooldown = weapon.COOLDOWN_DURATION

func update(delta: float):
	if weapon.cooldown <= 0:
		state_machine.change(WeaponStates.IDLE)
