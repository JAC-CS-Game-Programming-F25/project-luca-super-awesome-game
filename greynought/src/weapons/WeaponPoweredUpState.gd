extends State
class_name WeaponPoweredUpState

var animation_finished: bool = false

func enter(parameters: Dictionary = {}):
	weapon.weapon_sprite.play(WeaponStates.POWEREDUP)
	animation_finished = false
	
	if not weapon.weapon_sprite.animation_finished.is_connected(_on_animation_finished):
		weapon.weapon_sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	animation_finished = true

func update(delta: float):
	if animation_finished:
		state_machine.change(WeaponStates.IDLE)

func exit():
	if weapon.weapon_sprite.animation_finished.is_connected(_on_animation_finished):
		weapon.weapon_sprite.animation_finished.disconnect(_on_animation_finished)
