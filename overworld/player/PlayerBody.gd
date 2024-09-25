extends CharacterBody2D


const SPEED: int = 200
var current_direction: int
var movement_paused: bool = false


func _ready():
	Events.pause_player_movement.connect(pause_movement)
	Events.resume_player_movement.connect(resume_movement)


func _physics_process(_delta):
	_player_movement()
	

func _player_movement():
	if (
		Input.is_action_pressed("ui_down") 
		and current_direction == Collections.directions.DOWN
		and !movement_paused
	):
		_play_animation(1)
		velocity.x = 0
		velocity.y = SPEED
	elif (
		Input.is_action_pressed("ui_down") 
		and current_direction != Collections.directions.DOWN
		and !movement_paused
	):
		current_direction = Collections.directions.DOWN
		_play_animation(0)
		velocity.x = 0
		velocity.y = 0
	elif (
		Input.is_action_pressed("ui_left") 
		and current_direction == Collections.directions.LEFT
		and !movement_paused
	):
		_play_animation(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif (
		Input.is_action_pressed("ui_left") 
		and current_direction != Collections.directions.LEFT
		and !movement_paused
	):
		current_direction = Collections.directions.LEFT
		_play_animation(0)
		velocity.x = 0
		velocity.y = 0
	elif (
		Input.is_action_pressed("ui_right") 
		and current_direction == Collections.directions.RIGHT
		and !movement_paused
	):
		_play_animation(1)
		velocity.x = SPEED
		velocity.y = 0
	elif (
		Input.is_action_pressed("ui_right") 
		and current_direction != Collections.directions.RIGHT
		and !movement_paused
	):
		_play_animation(0)
		velocity.x = 0
		velocity.y = 0
		current_direction = Collections.directions.RIGHT
	elif (
		Input.is_action_pressed("ui_up") 
		and current_direction == Collections.directions.UP
		and !movement_paused
	):
		_play_animation(1)
		velocity.x = 0
		velocity.y = -SPEED
	elif (
		Input.is_action_pressed("ui_up") 
		and current_direction != Collections.directions.UP
		and !movement_paused
	):
		current_direction = Collections.directions.UP
		_play_animation(0)
		velocity.x = 0
		velocity.y = 0
	else:
		_play_animation(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()


func pause_movement() -> void:
	movement_paused = true


func _play_animation(movement: int):
	var animation: Object = $AnimatedSprite2D
	
	match current_direction:
		Collections.directions.DOWN:
			animation.flip_h = false
			if movement == 1:
				animation.play("front_walk")
				Events.direction_changed.emit(Collections.directions.DOWN)
			elif movement == 0:
				animation.play("front_idle")
		Collections.directions.LEFT:
			animation.flip_h = true
			if movement == 1:
				animation.play("side_walk")
				Events.direction_changed.emit(Collections.directions.LEFT)
			elif movement == 0:
				animation.play("side_idle")
		Collections.directions.RIGHT:
			animation.flip_h = false
			if movement == 1:
				animation.play("side_walk")
				Events.direction_changed.emit(Collections.directions.RIGHT)
			elif movement == 0:
				animation.play("side_idle")
		Collections.directions.UP:
			animation.flip_h = false
			if movement == 1:
				animation.play("back_walk")
				Events.direction_changed.emit(Collections.directions.UP)
			elif movement == 0:
				animation.play("back_idle")


func resume_movement() -> void:
	movement_paused = false
