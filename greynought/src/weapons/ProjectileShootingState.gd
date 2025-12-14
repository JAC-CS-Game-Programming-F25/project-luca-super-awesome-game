extends State
class_name ProjectileShootingState

func enter(parameters: Dictionary = {}):
	weapon.weapon_sprite.play(WeaponStates.SHOOTING)
	weapon.shoot_projectile()
	# TODO: Play shooting sound
	state_machine.change(WeaponStates.COOLDOWN)
