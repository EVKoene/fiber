extends Node


@onready var save_path := "user://savedata/"
@onready var overworld_file := str(save_path, "overworld.ini")

var can_move := true
var overworld_textbox: OverworldTextbox


func save_player_position() -> void:
	var config := ConfigFile.new()
	if FileAccess.file_exists(overworld_file):
		config.load(overworld_file)
	
	var player_position: Vector2 = GameManager.current_scene.player_position
	var current_scene_id: int = GameManager.current_scene.scene_id
	
	config.set_value("player", "position", player_position)
	config.set_value("overworld", "area_id", current_scene_id)
	config.save(overworld_file)
