extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.direction_changed.connect(_change_collision_shape_direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_colliding() and Input.is_action_just_pressed("ui_accept") and OverworldManager.can_move:
		OverworldManager.can_move = false
		Events.npc_interaction_started.emit(get_collider().npc_id)


func _change_collision_shape_direction(direction: int) -> void:
	match direction:
		Collections.directions.DOWN:
			target_position = Vector2(0.0, 40.0)
		Collections.directions.LEFT:
			target_position = Vector2(-40.0, 0.0)
		Collections.directions.RIGHT:
			target_position = Vector2(40.0, 0.0)
		Collections.directions.UP:
			target_position = Vector2(0.0, -40.0)
