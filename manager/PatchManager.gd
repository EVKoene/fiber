extends Node


func check_version() -> void:
	var config := ConfigFile.new()
	config.load(GameManager.collections_path)
	if config.get_value("version", "local_version", "") == "":
		# We start keeping track of patches 0.0.3. We want to remove old savefiles from people
		# playing before that time.
		clean_outdated_save()
		set_version()


func clean_outdated_save() -> void:
	DirAccess.remove_absolute(GameManager.collections_path)
	DirAccess.remove_absolute(OverworldManager.overworld_file)


func set_version() -> void:
	var config := ConfigFile.new()
	config.load(GameManager.collections_path)
	config.set_value("version", "local_version", GameManager.version)
	
	var save_error := config.save(GameManager.collections_path)
	if save_error:
		print("Error creating card collection: ", error_string(save_error))
