extends State
class_name HitscanBlastShootingState

func enter(parameters: Dictionary = {}):
	weapon.weapon_sprite.play(WeaponStates.SHOOTING)
	weapon.shoot_hitscan_blast()
	state_machine.change(WeaponStates.COOLDOWN)
