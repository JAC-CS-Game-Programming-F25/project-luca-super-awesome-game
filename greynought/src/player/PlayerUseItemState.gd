extends State
class_name PlayerUseItemState

var animation_finished: bool = false

func enter(parameters: Dictionary = {}):
	player.play_animation(PlayerStates.USEITEM)
	player.velocity.x = 0
	animation_finished = false
	
	if not player.body_sprites.animation_finished.is_connected(_on_animation_finished):
		player.body_sprites.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	animation_finished = true

func update(delta: float):
	player.update_facing_direction()
	
	if animation_finished:
		if player.is_on_floor():
			state_machine.change(PlayerStates.IDLE)
		else:
			state_machine.change(PlayerStates.JUMPING)

func exit():
	if player.body_sprites.animation_finished.is_connected(_on_animation_finished):
		player.body_sprites.animation_finished.disconnect(_on_animation_finished)
