extends Area2D


@export var scene_id: int


func _on_body_entered(body: Node2D):
	if body.is_in_group("PlayerBody"):
		TransitionScene.transition_to_overworld_scene(scene_id, get_parent().scene_id)
