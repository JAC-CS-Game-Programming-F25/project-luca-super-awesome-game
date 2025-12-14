extends Node2D
class_name Room

var enemies: Array = []
var traps: Array = []
var is_cleared: bool = false

func _ready():
	load_room()

func load_room():
	spawn_enemies()
	
	traps = get_tree().get_nodes_in_group("traps")

func spawn_enemies():
	enemies = get_tree().get_nodes_in_group("enemies")

func clear():
	var alive_enemies = 0
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.health > 0:
			alive_enemies += 1
	
	if alive_enemies == 0:
		is_cleared = true
		print("Room cleared!")

func _process(delta):
	if not is_cleared:
		check_clear_condition()

func check_clear_condition():
	var alive_enemies = 0
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.health > 0:
			alive_enemies += 1
	
	if alive_enemies == 0 and enemies.size() > 0:
		clear()
