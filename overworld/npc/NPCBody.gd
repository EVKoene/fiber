extends CharacterBody2D

class_name NPCBody

@export var direction: int
var npc_id: int


func setup_npc(id_to_set: int, direction_to_set: int) -> void:
	npc_id = id_to_set
	direction = direction_to_set
	play_animation(npc_id, direction, Collections.animation_types.IDLE)


func play_animation(animation_npc_id: int, animation_direction: int, animation_types: int) -> void:
	$AnimatedSprite2D.play(
		NPCDatabase.npc_animation(animation_npc_id, animation_direction, animation_types)
	)
	if animation_direction == Collections.directions.LEFT:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func face_towards_player() -> void:
	var coordinates: Vector2 = GameManager.current_scene.player_body.position
	if (
		abs(coordinates.x - position.x) > abs(coordinates.y - position.y)
		and coordinates.x > position.x
	):
		play_animation(npc_id, Collections.directions.RIGHT, Collections.animation_types.IDLE)
	elif (
		abs(coordinates.x - position.x) > abs(coordinates.y - position.y)
		and coordinates.x < position.x
	):
		play_animation(npc_id, Collections.directions.LEFT, Collections.animation_types.IDLE)
	elif (
		abs(coordinates.x - position.x) < abs(coordinates.y - position.y)
		and coordinates.y > position.y
	):
		play_animation(npc_id, Collections.directions.DOWN, Collections.animation_types.IDLE)
	elif (
		abs(coordinates.x - position.x) < abs(coordinates.y - position.y)
		and coordinates.y < position.y
	):
		play_animation(npc_id, Collections.directions.UP, Collections.animation_types.IDLE)
