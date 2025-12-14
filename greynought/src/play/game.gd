extends Node2D

var current_level: int = 1
var timer: float = 0.0
var is_running: bool = false
var player: CharacterBody2D
var current_level_scene: Level
var level_script = preload("res://src/play/level.gd")

func _ready():
	start()

func _process(delta):
	if is_running:
		timer += delta

func start():
	is_running = true
	timer = 0.0
	current_level = 1
	
	load_level(current_level)

func load_level(level_num: int):
	if current_level_scene:
		current_level_scene.queue_free()
	
	var level = Level.new()
	level.amount_of_rooms = 5 + (level_num * 2)
	level.set_script(level_script)
	current_level_scene = level
	add_child(current_level_scene)
	
	spawn_player()

func spawn_player():
	if not player:
		var player_scene = preload("res://src/player.tscn")
		player = player_scene.instantiate()
		add_child(player)
	
	# Get spawn point from current room, not level
	var current_room = current_level_scene.get_current_room()
	if current_room:
		var spawn_point = current_room.get_node_or_null("PlayerSpawn")
		if spawn_point:
			player.global_position = spawn_point.global_position
			print("Spawned player at: ", spawn_point.global_position)
		else:
			print("No PlayerSpawn found in room!")
			player.global_position = Vector2(100, 100)
	else:
		print("No current room!")
		player.global_position = Vector2(100, 100)
	
	if not player.is_connected("died", _on_player_died):
		player.connect("died", _on_player_died)

func next_level():
	current_level += 1
	load_level(current_level)

func _on_player_died():
	end(false)

func save_score():
	var save_data = {
		"time": timer,
		"level": current_level,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
	
	print("Score saved! Time: ", timer)

func end(victory: bool):
	is_running = false
	
	if victory:
		print("Victory! Time: ", timer)
		save_score()
	else:
		print("Game Over!")
	
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

func get_current_state() -> Dictionary:
	return {
		"level": current_level,
		"timer": timer,
		"is_running": is_running,
		"player_health": player.health if player else 0,
		"player_coins": player.coins if player else 0
	}
