extends CharacterBody2D

signal died

# Constants
const SPEED = 400.0
const JUMP_VELOCITY = -800.0
const GRAVITY = 980.0

# Player stats
var health: int = 100
var coins: int = 0
var invincible_timer: float = 0.0

# References
@onready var body_sprites = $BodySprite
@onready var state_machine = $StateMachine
@onready var weapon = $weapon

func _ready():
	# Add all states
	state_machine.add(PlayerStates.IDLE, PlayerIdleState.new())
	state_machine.add(PlayerStates.WALKING, PlayerWalkingState.new())
	state_machine.add(PlayerStates.JUMPING, PlayerJumpingState.new())
	state_machine.add(PlayerStates.USEITEM, PlayerUseItemState.new())
	state_machine.add(PlayerStates.DAMAGED, PlayerDamagedState.new())
	state_machine.add(PlayerStates.INVINCIBLE, PlayerInvincibilityState.new())
	state_machine.add(PlayerStates.DEAD, PlayerDeathState.new())
	
	# Start with idle state
	state_machine.change(PlayerStates.IDLE)

func _process(delta):
	state_machine.update(delta)
	
	# Update invincibility timer
	if invincible_timer > 0:
		invincible_timer -= delta

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	state_machine.physics_update(delta)
	move_and_slide()

func update_facing_direction():
	# Get mouse position in world space
	var mouse_pos = get_global_mouse_position()
	var player_pos = global_position
	
	# Flip sprite based on whether mouse is left or right of player
	if mouse_pos.x < player_pos.x:
		body_sprites.flip_h = false
	else:
		body_sprites.flip_h = true

func take_damage(amount: int, damage_direction: int = -1):
	if invincible_timer <= 0:
		health -= amount
		state_machine.change(PlayerStates.DAMAGED, {"damage": amount, "direction": damage_direction})
		weapon.state_machine.change(WeaponStates.DAMAGED)
		
		if health <= 0:
			state_machine.change(PlayerStates.DEAD)
			weapon.state_machine.change(WeaponStates.DEAD)
			
			died.emit()

func activate_invincible(duration: float):
	invincible_timer = duration
	state_machine.change(PlayerStates.INVINCIBLE, {"duration": duration})
	weapon.state_machine.change(WeaponStates.INVINCIBLE)

func collect_coin():
	coins += 1

func use_item():
	state_machine.change(PlayerStates.USEITEM)
	weapon.state_machine.change(WeaponStates.POWEREDUP)

func play_animation(anim_name: String):
	body_sprites.play(anim_name)

func set_flip(flip: bool):
	body_sprites.flip_h = flip
