extends Node

@onready var save_path := "user://savedata/"
@onready var overworld_file := str(save_path, "overworld.ini")

var defeated_npc_ids: Array:
	get = _get_defeated_npc_ids


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


func _get_defeated_npc_ids() -> Array:
	var config := ConfigFile.new()
	if FileAccess.file_exists(overworld_file):
		config.load(overworld_file)

	return config.get_value("progress", "defeated_npcs", [])
