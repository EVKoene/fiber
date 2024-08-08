extends Node2D


func _ready():
	$HailStormSprite.scale *= MapSettings.play_space_size / (
		$HailStormSprite.sprite_frames.get_frame_texture($HailStormSprite.animation, 0)
		.get_size()
	)
	
	$HailStormSprite.play("Hailstorm")
	
	$HailStormSprite.animation_finished.connect(queue_free)
