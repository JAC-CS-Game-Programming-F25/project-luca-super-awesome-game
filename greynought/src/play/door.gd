extends Area2D

@export var goes_forward: bool = true

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		var level = get_tree().get_first_node_in_group("level")
		if level:
			if goes_forward:
				level.transition_to_next_room()
			else:
				level.transition_to_previous_room()
