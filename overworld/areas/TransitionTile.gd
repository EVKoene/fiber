extends Area2D


@export var scene_id: int


func _on_body_entered(body: Node2D):
	if body.is_in_group("PlayerBody"):
		var new_position: Vector2 = AreaDatabase.areas[
			scene_id]["TransitionPosition"][get_parent().scene_id
		]
		TransitionScene.transition_to_overworld_scene(scene_id, new_position)
