extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var cooldown_bar = $CooldownBar

var player: CharacterBody2D
var weapon: Node2D

func _ready():
	player = get_parent()
	if player:
		weapon = player.get_node_or_null("weapon")

func _process(delta):
	if player and health_bar:
		update_health()
	
	if weapon and cooldown_bar:
		update_cooldown()

func update_health():
	var max_health = 100
	var current_health = player.health
	health_bar.value = (float(current_health) / max_health) * 100

func update_cooldown():
	var max_cooldown = weapon.COOLDOWN_DURATION
	var current_cooldown = weapon.cooldown
	
	if current_cooldown > 0:
		cooldown_bar.value = ((max_cooldown - current_cooldown) / max_cooldown) * 100
	else:
		cooldown_bar.value = 100
