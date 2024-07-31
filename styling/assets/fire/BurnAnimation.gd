extends Node2D

func _ready():
	$AnimatedSprite2D.scale *= MapSettings.play_space_size / (
		$AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation, 0)
		.get_size()
	) / 2 
	$AnimatedSprite2D.play("Burn")
	$AnimatedSprite2D.animation_finished.connect(queue_free)
