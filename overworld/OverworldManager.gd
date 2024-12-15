extends Node


@onready var save_path := "user://savedata/"
@onready var overworld_file := str(save_path, "overworld.ini")

var can_move := true
var overworld_textbox: OverworldTextbox


func save_player_position() -> void:
	var config := ConfigFile.new()
	if FileAccess.file_exists(overworld_file):
		config.load(overworld_file)
	
	var player_position: Vector2 = GameManager.current_scene.player
