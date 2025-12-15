extends Node2D
class_name Room

var enemies: Array = []
var traps: Array = []
var is_cleared: bool = false

@onready var enemy_factory = EnemyFactory.new()

func _ready():
	load_room()

func load_room():
	traps = get_tree().get_nodes_in_group("traps")
	spawn_enemies()

func spawn_enemies():
	var num_enemies = randi_range(2, 5)
	var tilemap = get_node_or_null("TileMapLayer")
	
	for i in range(num_enemies):
		var spawn_pos = find_safe_spawn_position()
		if spawn_pos:
			var enemy = enemy_factory.create_enemy(EnemyTypes.LOBBER, spawn_pos)
			if enemy:
				add_child(enemy)
				enemies.append(enemy)

func find_safe_spawn_position() -> Vector2:
	var max_attempts = 20
	var tilemap = get_node_or_null("TileMapLayer")
	
	for attempt in range(max_attempts):
		var random_x = randf_range(100, 1800)
		var random_y = randf_range(100, 900)
		var test_pos = Vector2(random_x, random_y)
		
		if is_position_safe(test_pos, tilemap):
			return test_pos
	
	return Vector2(500, 300)

func is_position_safe(pos: Vector2, tilemap: TileMapLayer) -> bool:
	var min_distance_from_traps = 100.0
	for trap in traps:
		if pos.distance_to(trap.global_position) < min_distance_from_traps:
			return false
	
	var player_spawn = get_node_or_null("PlayerSpawn")
	if player_spawn and pos.distance_to(player_spawn.global_position) < 200.0:
		return false
	
	if tilemap:
		var tile_pos = tilemap.local_to_map(pos)
		var tile_data = tilemap.get_cell_tile_data(tile_pos)
		if tile_data:
			return false
	
	return true

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
