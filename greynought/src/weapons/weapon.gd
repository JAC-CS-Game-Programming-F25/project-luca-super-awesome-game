extends Node2D

# Weapon type
var weapon_type: String = WeaponTypes.PROJECTILE

# Weapon stats
var cooldown: float = 0.0
const COOLDOWN_DURATION: float = 0.5
var damage: int = 10

# Projectile weapon specific
var projectile_speed: float = 600.0
var projectile_lifetime: float = 2.0
var projectile_scene = preload("res://src/projectile.tscn")

# References
@onready var weapon_sprite = $WeaponSprite
@onready var collision_area = $CollisionArea
@onready var state_machine = $StateMachine

func _ready():
	setup_states()
	
	if collision_area:
		collision_area.body_entered.connect(_on_wall_entered)
		collision_area.body_exited.connect(_on_wall_exited)

func setup_states():
	state_machine.add(WeaponStates.IDLE, WeaponIdleState.new())
	state_machine.add(WeaponStates.COOLDOWN, WeaponCooldownState.new())
	state_machine.add(WeaponStates.WALLED, WeaponWalledState.new())
	state_machine.add(WeaponStates.POWEREDUP, WeaponPoweredUpState.new())
	state_machine.add(WeaponStates.DAMAGED, WeaponDamagedState.new())
	state_machine.add(WeaponStates.INVINCIBLE, WeaponInvincibilityState.new())
	state_machine.add(WeaponStates.DEAD, WeaponDeathState.new())
	
	match weapon_type:
		WeaponTypes.PROJECTILE:
			state_machine.add(WeaponStates.SHOOTING, ProjectileShootingState.new())
	
	state_machine.change(WeaponStates.IDLE)

func _process(delta):
	state_machine.update(delta)
	
	# Rotate toward mouse
	look_at(get_global_mouse_position())
	
	# Flip using scale when mouse is on left side
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x > global_position.x:
		scale = Vector2(-1.0, 1.0)  # Normal
	else:
		scale = Vector2(-1.0, -1.0)  # Flip vertically
	
	# Update cooldown
	if cooldown > 0:
		cooldown -= delta

func _physics_process(delta):
	state_machine.physics_update(delta)

func fire():
	if state_machine.current_state.name == WeaponStates.IDLE and cooldown <= 0:
		state_machine.change(WeaponStates.SHOOTING)

func shoot_projectile():
	var projectile = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	projectile.global_position = global_position + direction * 60  # OFFSET
	projectile.rotation = direction.angle()
	projectile.velocity = direction * projectile_speed
	projectile.damage = damage
	projectile.lifetime = projectile_lifetime

func _on_wall_entered(body):
	if state_machine.current_state.name != WeaponStates.WALLED:
		state_machine.change(WeaponStates.WALLED)

func _on_wall_exited(body):
	if state_machine.current_state.name == WeaponStates.WALLED:
		state_machine.change(WeaponStates.IDLE)
