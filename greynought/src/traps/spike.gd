extends Area2D

@export var damage: int = 10
@export var knockback_force: float = 300.0

func _ready():
	$Hit.body_entered.connect(stabbed)

func stabbed(body):
	if body.name == "Player":
		var knockback_direction = (body.global_position - global_position).normalized()
		
		body.velocity = -body.velocity + (knockback_direction * knockback_force)
		
		body.take_damage(damage, -sign(knockback_direction.x))
