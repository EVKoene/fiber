extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.direction_changed.connect(_change_collision_shape_direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_colliding() and Input.is_action_just_pressed("ui_accept"):
		Events.npc_interaction_started.emit(get_collider().get_instance_id())


func _change_collision_shape_direction(direction: int) -> void:
	match direction:
		Collections.directions.DOWN:
			target_position = Vector2(0.0, 16.0)
		Collections.directions.LEFT:
			target_position = Vector2(-16.0, 0.0)
		Collections.directions.RIGHT:
			target_position = Vector2(16.0, 0.0)
		Collections.directions.UP:
			target_position = Vector2(0.0, -16.0)
