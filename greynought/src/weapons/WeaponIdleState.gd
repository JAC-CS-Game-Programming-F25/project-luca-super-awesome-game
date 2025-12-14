extends State
class_name WeaponIdleState

func enter(parameters: Dictionary = {}):
	weapon.weapon_sprite.play(WeaponStates.IDLE)

func update(delta: float):
	if Input.is_action_pressed(InputKeys.MOVE_SHOOT):  # Left click
		weapon.fire()
