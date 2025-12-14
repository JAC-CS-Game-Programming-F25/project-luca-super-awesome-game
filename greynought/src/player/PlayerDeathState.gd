extends State
class_name PlayerDeathState

var death_timer: float = 0.0
const DEATH_ANIMATION_DURATION: float = 2.0

func enter(parameters: Dictionary = {}):
	player.play_animation(PlayerStates.DEAD)
	player.velocity.x = 0
	death_timer = 0.0

func update(delta: float):
	death_timer += delta
	
	player.body_sprites.modulate.a = 1.0 - (death_timer / DEATH_ANIMATION_DURATION)
	
	if death_timer >= DEATH_ANIMATION_DURATION:
		get_tree().reload_current_scene()

func physics_update(delta: float):
	player.velocity.y += player.GRAVITY * delta * 0.5
