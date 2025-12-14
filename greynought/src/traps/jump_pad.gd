extends StaticBody2D

@export var launch_force: float = -800.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var launch_area = $LaunchArea

func _ready():
	animated_sprite.play("jumppad-idle")
	launch_area.body_entered.connect(_on_launch_area_entered)
	
	if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_launch_area_entered(body):
	if body.is_in_group("player") or body is CharacterBody2D:
		body.velocity.y = launch_force
		animated_sprite.play("jumppad-active")

func _on_animation_finished():
	animated_sprite.play("jumppad-idle")
