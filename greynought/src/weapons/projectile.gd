extends Area2D

var velocity: Vector2 = Vector2.ZERO
var damage: int = 10
var lifetime: float = 2.0

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Play projectile animation
	animated_sprite.play("default")  # Change "default" to your animation name
	
	# Auto-destroy after lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	position += velocity * delta

func _on_body_entered(body):
	# Hit something
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	queue_free()  # Destroy projectile
