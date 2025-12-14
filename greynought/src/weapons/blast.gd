extends Area2D

var damage: int = 25

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)
	
	if animated_sprite:
		animated_sprite.play("default")
		animated_sprite.animation_finished.connect(_on_animation_finished)
	
	show_debug_box()

func _on_body_entered(body):
	if body.has_method("take_damage") and body.is_in_group("enemies"):
		body.take_damage(damage)

func _on_animation_finished():
	queue_free()

func show_debug_box():
	var collision_shape = $CollisionShape2D
	if collision_shape and collision_shape.shape:
		var box = ColorRect.new()
		box.color = Color(1, 0.5, 0, 0.5)
		box.size = collision_shape.shape.size
		box.position = -collision_shape.shape.size / 2
		add_child(box)
		
		var tween = create_tween()
		tween.tween_property(box, "modulate:a", 0.0, 0.3)
		tween.tween_callback(box.queue_free)
