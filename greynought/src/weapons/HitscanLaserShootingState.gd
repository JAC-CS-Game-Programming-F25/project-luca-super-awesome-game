extends State
class_name HitscanLaserShootingState

func enter(parameters: Dictionary = {}):
	weapon.weapon_sprite.play(WeaponStates.SHOOTING)
	weapon.shoot_hitscan_laser()
	state_machine.change(WeaponStates.COOLDOWN)
