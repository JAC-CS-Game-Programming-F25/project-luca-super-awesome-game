extends State
class_name WeaponWalledState

func enter(parameters: Dictionary = {}):
	weapon.weapon_sprite.play(WeaponStates.WALLED)
	# Stays in this state until collision exits (handled by weapon.gd)
