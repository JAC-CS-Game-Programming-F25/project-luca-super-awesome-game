extends Enemy
class_name Lobber

var projectile_speed: float = 400.0
var projectile_scene = preload("res://src/enemy/lobber_projectile.gd")

func _ready():
	super._ready()
	health = 30
	damage = 15
	attack_range = 350.0

func attack():
	if cooldown <= 0 and player:
		shoot_projectile()
		cooldown = 2.0

func shoot_projectile():
	var projectile = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	
	var direction = (player.global_position - weapon.global_position).normalized()
	
	projectile.global_position = weapon.global_position
	projectile.rotation = direction.angle()
	projectile.velocity = direction * projectile_speed
	projectile.damage = damage
