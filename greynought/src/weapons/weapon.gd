extends Node2D

var weapon_type: String = WeaponTypes.PROJECTILE

var cooldown: float = 0.0
const COOLDOWN_DURATION: float = 0.5
var damage: int = 10

var projectile_speed: float = 1200.0
var projectile_lifetime: float = 2.0
var projectile_scene = preload("res://src/projectile.tscn")

var blast_damage: int = 25
var blast_scene = preload("res://blast.tscn")

var laser_damage: int = 15
var laser_length: float = 800.0
var laser_width: float = 10.0

@onready var projectile_sprite = $ProjectileSprite
@onready var blast_sprite = $BlastSprite
@onready var laser_sprite = $LaserSprite
@onready var weapon_sprite
@onready var collision_area = $CollisionArea
@onready var state_machine = $StateMachine

func _ready():
	match weapon_type:
		WeaponTypes.PROJECTILE:
			weapon_sprite = projectile_sprite
			blast_sprite.visible = false
			laser_sprite.visible = false
		WeaponTypes.HITSCAN_BLAST:
			weapon_sprite = blast_sprite
			projectile_sprite.visible = false
			laser_sprite.visible = false
		WeaponTypes.HITSCAN_LASER:
			weapon_sprite = laser_sprite
			projectile_sprite.visible = false
			blast_sprite.visible = false
	
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
		WeaponTypes.HITSCAN_BLAST:
			state_machine.add(WeaponStates.SHOOTING, HitscanBlastShootingState.new())
		WeaponTypes.HITSCAN_LASER:
			state_machine.add(WeaponStates.SHOOTING, HitscanLaserShootingState.new())
	
	state_machine.change(WeaponStates.IDLE)

func _process(delta):
	state_machine.update(delta)
	
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x > global_position.x:
		scale = Vector2(-1.0, 1.0)
		position.x = -10
	else:
		scale = Vector2(-1.0, -1.0)
		position.x = 10
	
	look_at(get_global_mouse_position())
	
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
	
	projectile.global_position = global_position + direction * 60
	projectile.rotation = direction.angle()
	projectile.velocity = direction * projectile_speed
	projectile.damage = damage
	projectile.lifetime = projectile_lifetime

func shoot_hitscan_blast():
	var blast = blast_scene.instantiate()
	get_tree().root.add_child(blast)
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	blast.global_position = global_position + direction * 60
	blast.rotation = direction.angle()
	blast.damage = blast_damage

func _on_wall_entered(body):
	if state_machine.current_state.name != WeaponStates.WALLED:
		state_machine.change(WeaponStates.WALLED)

func _on_wall_exited(body):
	if state_machine.current_state.name == WeaponStates.WALLED:
		state_machine.change(WeaponStates.IDLE)

func shoot_hitscan_laser():
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	var start_pos = global_position + direction * 40
	var end_pos = start_pos + direction * laser_length
	
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	query.collision_mask = 2
	
	var result = space_state.intersect_ray(query)
	
	var laser_end = end_pos
	if result:
		laser_end = result.position
		if result.collider.has_method("take_damage") and result.collider.is_in_group("enemies"):
			result.collider.take_damage(laser_damage)
	
	show_laser_effect(start_pos, laser_end)

func show_laser_effect(start: Vector2, end: Vector2):
	var laser_line_outer = Line2D.new()
	laser_line_outer.add_point(start)
	laser_line_outer.add_point(end)
	laser_line_outer.width = laser_width
	laser_line_outer.default_color = Color(1, 0, 0, 0.8)
	get_tree().root.add_child(laser_line_outer)
	
	var laser_line_inner = Line2D.new()
	laser_line_inner.add_point(start)
	laser_line_inner.add_point(end)
	laser_line_inner.width = laser_width / 3
	laser_line_inner.default_color = Color(1, 1, 1, 1)
	get_tree().root.add_child(laser_line_inner)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(laser_line_outer, "modulate:a", 0.0, 0.2)
	tween.tween_property(laser_line_inner, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(laser_line_outer.queue_free)
	tween.tween_callback(laser_line_inner.queue_free)
