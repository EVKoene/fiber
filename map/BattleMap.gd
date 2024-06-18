extends Node2D

@onready var total_screen: Vector2 = Vector2(get_viewport().size)
@onready var play_space_scene: PackedScene = preload("res://map/PlaySpace.tscn")
@onready var card_scene: PackedScene = preload("res://card/CardInPlay.tscn")

var map = MapDatabase.maps.BASE_MAP
var map_data = MapDatabase.map_data[map]


func _ready():
	_add_spawnable_scenes()
	_create_battle_map()
	if multiplayer.is_server():
		GameManager.is_server = true
	else:
		return
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		var card = card_scene.instantiate()
		card.column = 4
		if p_id == GameManager.p1_id:
			card.row = 0
		else:
			card.row = 4
		card.card_index = 1
		card.card_owner_id = p_id
		add_child(card, true)


func _add_spawnable_scenes() -> void:
	$MultiplayerSpawner.add_spawnable_scene("res://map/PlaySpace.tscn")
	$MultiplayerSpawner.add_spawnable_scene("res://card/CardInPlay.tscn")


func _create_battle_map() -> void:
	_set_area_sizes()
	_set_play_space_size()
	_create_play_spaces()


func _set_area_sizes() -> void:
	MapSettings.play_area_size = total_screen * Vector2(0.8, 0.9)
	MapSettings.p2_area_start = Vector2(0, 0)
	MapSettings.p2_area_end = Vector2(
		MapSettings.play_area_size.x, (total_screen.y - MapSettings.play_area_size.y) / 2
	)

	MapSettings.play_area_start = Vector2(0, (total_screen.y - MapSettings.play_area_size.y) / 2)
	MapSettings.play_area_end = Vector2(
		MapSettings.play_area_size.x, 
		MapSettings.play_area_size.y + (total_screen.y - MapSettings.play_area_size.y) / 2
	)

	MapSettings.p1_area_start = Vector2(
		0, MapSettings.play_area_size.y + (total_screen.y - MapSettings.play_area_size.y) / 2
	)
	MapSettings.p1_area_end = Vector2(MapSettings.play_area_size.x, total_screen.y)


func _set_play_space_size() -> void:
	var min_column_length: float = MapSettings.play_area_size.x / float(map_data["Columns"])
	var min_row_length: float = MapSettings.play_area_size.y / float(map_data["Rows"])
	
	var ps_size: int = min(min_column_length, min_row_length)

	MapSettings.play_space_size = Vector2(ps_size, ps_size)
	MapSettings.card_in_play_size = Vector2(ps_size, ps_size) * 0.8


func _create_play_spaces() -> void:
	var n_play_spaces: int = 0
	for column in map_data["Columns"]:
		MapSettings.number_of_columns += 1
		GameManager.play_spaces_by_position[column] = {}
		for row in map_data["Rows"]:
			var play_space: PlaySpace = play_space_scene.instantiate()
			play_space.column = column
			play_space.row = row
			play_space.name = str(n_play_spaces)

			if multiplayer.is_server():
				add_child(play_space, true)
				GameManager.play_spaces.append(play_space)
			GameManager.play_spaces_by_position[column][row] = play_space
			n_play_spaces += 1

	for row in map_data["Rows"]:
		MapSettings.number_of_rows += 1
