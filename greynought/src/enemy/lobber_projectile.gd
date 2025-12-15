extends Area2D

var velocity: Vector2 = Vector2.ZERO
var damage: int = 10
var lifetime: float = 3.0

func _ready():
	body_entered.connect(_on_body_entered)
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	position += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			var direction = 1 if velocity.x > 0 else -1
			body.take_damage(damage, direction)
	
	queue_free()
