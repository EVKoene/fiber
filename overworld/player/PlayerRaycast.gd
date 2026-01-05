extends RayCast2D


class_name PlayerRaycast

var interaction_in_progress := false
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.direction_changed.connect(_change_collision_shape_direction)
	GameManager.raycast = self


func _unhandled_input(event: InputEvent) -> void:
	if interaction_in_progress:
		return
	
	if is_colliding() and Input.is_action_just_pressed("ui_accept") and OverworldManager.can_move:
		interaction_in_progress = true
		
		if get_collider() is NPCBody:
			OverworldManager.can_move = false
			get_collider().face_towards_player()
			Events.npc_interaction_started.emit(get_collider().npc_id)
		if get_collider() is Sign:
			get_collider().read_sign_text()


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
