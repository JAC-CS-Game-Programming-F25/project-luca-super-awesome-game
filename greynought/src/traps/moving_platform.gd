extends AnimatableBody2D

@export var move_distance: float = 200.0  # How far to move (in pixels)
@export var move_duration: float = 3.0  # Time to complete one way trip
@export var start_direction: Vector2 = Vector2.RIGHT  # Direction to move

@onready var start_position: Vector2 = global_position
var tween: Tween

func _ready():
	start_moving()

func start_moving():
	move_to_end()

func move_to_end():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)  # Smooth ease in/out
	tween.set_ease(Tween.EASE_IN_OUT)  # Slower at start/end, faster in middle
	
	var end_position = start_position + (start_direction.normalized() * move_distance)
	tween.tween_property(self, "global_position", end_position, move_duration)
	tween.tween_callback(move_to_start)

func move_to_start():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "global_position", start_position, move_duration)
	tween.tween_callback(move_to_end)
