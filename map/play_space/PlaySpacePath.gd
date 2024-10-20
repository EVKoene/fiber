extends Node


class_name PlaySpacePath

@onready var play_space_arrow_scene: PackedScene = preload("res://map/play_space/PlaySpaceArrow.tscn")

var path_spaces: Array
var last_space: PlaySpace
var first_space: PlaySpace
var goal_space_occupied: bool
var ignore_obstacles: bool = false
var path_length: int: get = _get_path_length


func _init(_last_space: PlaySpace, _first_space: PlaySpace, _ignore_obstacles := false):
	last_space = _last_space
	first_space = _first_space
	ignore_obstacles = _ignore_obstacles


func _ready():
	path_spaces = find_path(first_space, last_space)



func extend_path(goal_space: PlaySpace) -> PlaySpacePath:
	last_space = goal_space
	# Trying to extend an empty path should return an empty path rather than giving an error
	if path_length == 0:
		path_spaces = []
		return self
	
	var extended_path: Array = find_path(path_spaces.back(), goal_space)
	# Remove the first index so it isn't added twice
	extended_path.remove_at(0)
	path_spaces += extended_path
	
	return self


func find_path(starting_space: PlaySpace, goal_space: PlaySpace) -> Array:
	var play_spaces = []
	var queue: Array = [starting_space]

	var distance: Dictionary = {
		starting_space: 0,
	}
	var came_from: Dictionary = {
		starting_space: null,
	}
	while len(queue) > 0:
		var ps = queue.pop_front()
		if ps == goal_space:
			break

		for adj_ps in ps.adjacent_play_spaces():
			if adj_ps not in distance and (
				!adj_ps.card_in_this_play_space or ignore_obstacles
			):
				queue.append(adj_ps)
				came_from[adj_ps] = ps
				distance[adj_ps] = 1 + distance[ps]

	if goal_space not in distance:
		play_spaces = []

	else:
		play_spaces = [goal_space]
		while play_spaces[0] != starting_space:
			for ps in distance:
				if came_from[play_spaces[0]] == ps and distance[play_spaces[0]] == distance[ps] + 1:
					play_spaces.push_front(ps)
	
	return play_spaces


func show_path() -> void:
	for index in range(len(path_spaces) - 1):
		var arrow = play_space_arrow_scene.instantiate()
		arrow.position.x = path_spaces[index].position.x + MapSettings.play_space_size.x / 2
		arrow.position.y = path_spaces[index].position.y
		arrow.scale *= MapSettings.play_space_size / arrow.size
		GameManager.lobby.battle_map.add_child(arrow)
		
		var next_column_higher: bool = path_spaces[index + 1].column > path_spaces[index].column
		var next_column_lower: bool = path_spaces[index + 1].column < path_spaces[index].column
		var next_row_higher: bool = path_spaces[index + 1].row > path_spaces[index].row
		var next_row_lower: bool = path_spaces[index + 1].row < path_spaces[index].row
		
		# TODO: Setting the position after rotating should be done with pivot_offset, but I
		# can't figure it out so I'm leaving it for later
		if (
			(GameManager.lobby.is_player_1 and next_column_higher)
			or (!GameManager.lobby.is_player_1 and next_column_lower)
		):
			arrow.rotation_degrees = 0
		elif (
			(GameManager.lobby.is_player_1 and next_column_lower)
			or (!GameManager.lobby.is_player_1 and next_column_higher)
		):
			arrow.rotation_degrees = 180
			arrow.position.y += MapSettings.play_space_size.y
		elif (
			(GameManager.lobby.is_player_1 and next_row_higher)
			or (!GameManager.lobby.is_player_1 and next_row_lower)
		):
			arrow.rotation_degrees = 90
			arrow.position.x += MapSettings.play_space_size.x / 2
			arrow.position.y += MapSettings.play_space_size.y / 2
		elif (
			(GameManager.lobby.is_player_1 and next_row_lower)
			or (!GameManager.lobby.is_player_1 and next_row_higher)
		):
			arrow.rotation_degrees = 270
			arrow.position.x -= MapSettings.play_space_size.x / 2
			arrow.position.y += MapSettings.play_space_size.y / 2
		TargetSelection.play_space_arrows.append(arrow)


func _get_path_length() -> int:
	return len(path_spaces)
