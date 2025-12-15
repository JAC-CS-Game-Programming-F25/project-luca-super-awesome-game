extends Node
class_name EnemyFactory

var enemy_scenes = {
	EnemyTypes.LOBBER: preload("res://lobber.tscn"),
}

func create_enemy(type: String, position: Vector2) -> CharacterBody2D:
	if enemy_scenes.has(type):
		var enemy = enemy_scenes[type].instantiate()
		enemy.global_position = position
		return enemy
	
	print("Enemy type not found: ", type)
	return null

func create_random_enemy(level: int) -> CharacterBody2D:
	var enemy_type = EnemyTypes.LOBBER
	
	var enemy = create_enemy(enemy_type, Vector2.ZERO)
	
	if enemy:
		scale_enemy_to_level(enemy, level)
	
	return enemy

func scale_enemy_to_level(enemy: CharacterBody2D, level: int):
	if enemy.has("health"):
		enemy.health += level * 10
	if enemy.has("damage"):
		enemy.damage += level * 2
