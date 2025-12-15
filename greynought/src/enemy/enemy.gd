extends CharacterBody2D
class_name Enemy

signal died

var health: int = 50
var active: bool = false
var cooldown: float = 0.0
var damage: int = 10
var detection_range: float = 400.0
var attack_range: float = 300.0

@onready var sprite = $Sprite
@onready var weapon = $Weapon
@onready var detection_area = $DetectionArea

var player: CharacterBody2D

func _ready():
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")
	
	if detection_area:
		detection_area.body_entered.connect(_on_detection_entered)
		detection_area.body_exited.connect(_on_detection_exited)

func _process(delta):
	if cooldown > 0:
		cooldown -= delta
	
	if active and player:
		detect_player()
		if can_attack():
			attack()

func detect_player():
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance <= detection_range:
			active = true
			face_player()
		else:
			active = false

func face_player():
	if player and weapon:
		weapon.look_at(player.global_position)
		
		if player.global_position.x > global_position.x:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

func can_attack() -> bool:
	if not player:
		return false
	
	var distance = global_position.distance_to(player.global_position)
	return distance <= attack_range and cooldown <= 0

func attack():
	pass

func move():
	pass

func take_damage(amount: int):
	health -= amount
	
	if health <= 0:
		die()

func die():
	died.emit()
	queue_free()

func _on_detection_entered(body):
	if body.is_in_group("player"):
		active = true

func _on_detection_exited(body):
	if body.is_in_group("player"):
		active = false
