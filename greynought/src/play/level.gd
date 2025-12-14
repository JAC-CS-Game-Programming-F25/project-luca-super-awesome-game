extends Node2D
class_name Level

@export var amount_of_rooms: int = 1
@export var room_folder_path: String = "res://src/rooms/"

var rooms: Array[Room] = []
var current_room_index: int = 0
var current_room: Room

func _ready():
	add_to_group("level")
	generate()

func generate():
	var room_files = get_room_files()
	
	if room_files.is_empty():
		print("No room scenes found in ", room_folder_path)
		return
	
	for i in range(amount_of_rooms):
		var random_room_file = room_files[randi() % room_files.size()]
		var room = load(random_room_file).instantiate()
		rooms.append(room)
	
	load_room(0)

func get_room_files() -> Array[String]:
	var files: Array[String] = []
	var dir = DirAccess.open(room_folder_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				files.append(room_folder_path + file_name)
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		print("Failed to open room folder: ", room_folder_path)
	
	return files

func load_room(room_index: int):
	if current_room:
		remove_child(current_room)
	
	current_room_index = room_index
	current_room = rooms[room_index]
	add_child(current_room)
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var spawn_point = current_room.get_node_or_null("PlayerSpawn")
		if spawn_point:
			player.global_position = spawn_point.global_position

func transition_to_next_room():
	if current_room_index < rooms.size() - 1:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			tween_room_transition(player, true)
	else:
		level_completed()

func transition_to_previous_room():
	if current_room_index > 0:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			tween_room_transition(player, false)

func tween_room_transition(player: CharacterBody2D, go_forward: bool):
	player.set_physics_process(false)
	
	var room_offset = Vector2(1920, 0)
	var new_room_index = current_room_index + (1 if go_forward else -1)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	var player_offset = room_offset if go_forward else -room_offset
	var target_player_pos = player.global_position + player_offset
	
	tween.tween_property(player, "global_position", target_player_pos, 1.0)
	
	await tween.finished
	
	current_room.clear()
	load_room(new_room_index)
	
	player.set_physics_process(true)

func level_completed():
	var game = get_parent()
	if game.has_method("next_level"):
		game.next_level()

func get_current_room() -> Room:
	return current_room
