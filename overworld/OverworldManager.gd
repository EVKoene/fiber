extends Node


@onready var save_path := "user://savedata/"
@onready var overworld_file := str(save_path, "overworld.ini")

var can_move := true
var overworld_textbox: OverworldTextbox
var current_player_position: Vector2 : get = _get_current_player_position
var saved_player_position: Vector2 : get = _get_saved_player_position
var current_area_id: int: get = _get_saved_area_id
var mc_question_textbox: OverworldTextboxMCOptions
var defeated_npc_ids: Array : get = _get_defeated_npc_ids


func defeat_npc(npc_id) -> void:
	var config := ConfigFile.new()
	if FileAccess.file_exists(overworld_file):
		config.load(overworld_file)
	
	var current_defeated_npc_ids: Array = config.get_value("progress", "defeated_npcs", [])
	if npc_id not in current_defeated_npc_ids:
		current_defeated_npc_ids.append(npc_id)
	
	config.set_value("progress", "defeated_npcs", current_defeated_npc_ids)
	config.save(overworld_file)


func create_overworld_file() -> void:
	var config := ConfigFile.new()
	if FileAccess.file_exists(overworld_file):
		return
	else:
		config.save(overworld_file)


func save_player_position() -> void:
	var config := ConfigFile.new()
	if FileAccess.file_exists(overworld_file):
		config.load(overworld_file)
	
	var position_to_save: Vector2 = current_player_position
	var current_scene_id: int = GameManager.current_scene.scene_id
	
	config.set_value("player", "position", position_to_save)
	config.set_value("overworld", "area_id", current_scene_id)
	config.save(overworld_file)


func _get_current_player_position() -> Vector2:
	return GameManager.current_scene.player_body.position


func _get_saved_player_position() -> Vector2:
	var config := ConfigFile.new()
	assert(
		FileAccess.file_exists(overworld_file), 
		"Couldn't find savefile to determine player position"
	)

	config.load(overworld_file)
	
	return config.get_value("player", "position")


func _get_saved_area_id() -> int:
	var config := ConfigFile.new()
	assert(
		FileAccess.file_exists(overworld_file), 
		"Couldn't find savefile to determine player position"
	)

	config.load(overworld_file)
	
	return config.get_value("overworld", "area_id")


func _get_defeated_npc_ids() -> Array:
	var config := ConfigFile.new()
	if FileAccess.file_exists(overworld_file):
		config.load(overworld_file)
		
	return config.get_value("progress", "defeated_npcs", [])
	
