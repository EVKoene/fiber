class_name BattleMapSetup

var play_space_scene: PackedScene = preload("res://map/play_space/PlaySpace.tscn")

var parent: BattleMap
var map: int
var map_data: Dictionary


func _init(battle_map: BattleMap) -> void:
	parent = battle_map
	map = MapDatabase.maps.BASE_MAP
	map_data = MapDatabase.map_data[map]


func create_battle_map() -> void:
	MapSettings.n_progress_bars = map_data["SpacesToWin"]
	_set_area_sizes()
	_set_play_space_size()
	_create_play_spaces()


func create_starting_territory() -> void:
	for ps in map_data["P1Territory"]:
		GameManager.ps_column_row[int(ps.x)][int(ps.y)].add_to_territory(GameManager.p1_id)
	for ps in map_data["P2Territory"]:
		GameManager.ps_column_row[int(ps.x)][int(ps.y)].add_to_territory(GameManager.p2_id)
	for ps in map_data["P1StartingConqueredSpaces"]:
		GameManager.ps_column_row[int(ps.x)][int(ps.y)].set_conquered_by(GameManager.p1_id)
	for ps in map_data["P2StartingConqueredSpaces"]:
		GameManager.ps_column_row[int(ps.x)][int(ps.y)].set_conquered_by(GameManager.p2_id)


func create_progress_bars() -> void:
	GameManager.progress_bars[GameManager.p1_id] = []
	GameManager.progress_bars[GameManager.p2_id] = []

	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		for b in MapSettings.n_progress_bars:
			var progress_bar = ProgressBar.new()
			var progress_bar_y_size = MapSettings.play_space_size.y / MapSettings.n_progress_bars
			parent.add_child(progress_bar)
			progress_bar.custom_minimum_size.x = MapSettings.play_space_size.x / 4
			progress_bar.custom_minimum_size.y = progress_bar_y_size
			progress_bar.position.x = MapSettings.get_column_end_x(MapSettings.n_columns) + b * progress_bar_y_size
			progress_bar.rotation_degrees = 90
			progress_bar.show_percentage = false
			var sb = StyleBoxFlat.new()
			progress_bar.add_theme_stylebox_override("fill", sb)
			GameManager.progress_bars[p_id].append(progress_bar)
			match [GameManager.is_player_1, p_id]:
				[true, GameManager.p1_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 + progress_bar.size.y
					sb.bg_color = Color.hex(0x3b3be7dc)
				[true, GameManager.p2_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 - progress_bar.size.y
					sb.bg_color = Color.hex(0xf3131edc)
				[false, GameManager.p1_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 - progress_bar.size.y
					sb.bg_color = Color.hex(0x3b3be7dc)
				[false, GameManager.p2_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 + progress_bar.size.y
					sb.bg_color = Color.hex(0xf3131edc)


func _set_area_sizes() -> void:
	MapSettings.play_area_size = MapSettings.total_screen * Vector2(0.8, 0.9)
	MapSettings.opponent_area_start = Vector2(0, 0)
	MapSettings.opponent_area_end = Vector2(
		MapSettings.play_area_size.x,
		(MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2
	)

	MapSettings.play_area_start = Vector2(
		0, (MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2
	)
	MapSettings.play_area_end = Vector2(
		MapSettings.play_area_size.x,
		(
			MapSettings.play_area_size.y
			+ (MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2
		)
	)

	MapSettings.own_area_start = Vector2(
		0,
		(
			MapSettings.play_area_size.y
			+ (MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2
		)
	)
	MapSettings.own_area_end = Vector2(MapSettings.play_area_size.x, MapSettings.total_screen.y)


func _set_play_space_size() -> void:
	var min_column_length: float = MapSettings.play_area_size.x / float(map_data["Columns"])
	var min_row_length: float = MapSettings.play_area_size.y / float(map_data["Rows"])

	var ps_size: int = min(min_column_length, min_row_length)

	MapSettings.play_space_size = Vector2(ps_size, ps_size)
	MapSettings.card_in_play_size = Vector2(ps_size, ps_size) * 0.9
	MapSettings.card_in_hand_size = Vector2(
		(MapSettings.own_area_end.x - MapSettings.own_area_start.x) / 7,
		MapSettings.own_area_end.y - MapSettings.own_area_start.y
	)
	MapSettings.card_option_size = MapSettings.card_in_play_size * 2


func _create_play_spaces() -> void:
	MapSettings.n_columns = map_data["Columns"]
	MapSettings.n_rows = map_data["Rows"]
	for column in map_data["Columns"]:
		GameManager.ps_column_row[column] = {}
		for row in map_data["Rows"]:
			var play_space: PlaySpace = play_space_scene.instantiate()
			play_space.column = column
			play_space.row = row
			parent.add_child(play_space)
			GameManager.play_spaces.append(play_space)
