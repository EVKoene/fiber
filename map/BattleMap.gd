extends Node2D

@onready var play_space_scene: PackedScene = preload("res://map/PlaySpace.tscn")
@onready var card_scene: PackedScene = preload("res://card/CardInPlay.tscn")
@onready var resource_bar_scene: PackedScene = preload("res://player/ResourceBar.tscn")

var map = MapDatabase.maps.BASE_MAP
var map_data = MapDatabase.map_data[map]


func _ready():
	_add_spawnable_scenes()
	_create_battle_map()
	_set_zoom_preview_position_and_size()
	_set_end_turn_button()
	_set_resource_bars_position_and_size()
	GameManager.cards_in_hand[GameManager.p1_id] = []
	GameManager.cards_in_hand[GameManager.p2_id] = []
	if multiplayer.is_server():
		GameManager.is_server = true
		GameManager.battle_map = self
		_add_players()


func _add_players() -> void:
	GameManager.p1 = Player.new(GameManager.p1_id, GameManager.players[GameManager.p1_id]["Deck"])
	add_child(GameManager.p1)
	GameManager.p2 = Player.new(GameManager.p2_id, GameManager.players[GameManager.p1_id]["Deck"])
	add_child(GameManager.p2)


func _add_spawnable_scenes() -> void:
	$MultiplayerSpawner.add_spawnable_scene("res://map/PlaySpace.tscn")
	$MultiplayerSpawner.add_spawnable_scene("res://card/CardInPlay.tscn")
	$MultiplayerSpawner.add_spawnable_scene("res://card/CardInHand.tscn")


func _create_battle_map() -> void:
	_set_area_sizes()
	_set_play_space_size()
	_create_play_spaces()


func _set_area_sizes() -> void:
	MapSettings.play_area_size = MapSettings.total_screen * Vector2(0.8, 0.9)
	MapSettings.opponent_area_start = Vector2(0, 0)
	MapSettings.opponent_area_end = Vector2(
		MapSettings.play_area_size.x, (
			MapSettings.total_screen.y - MapSettings.play_area_size.y
			) / 2
	)

	MapSettings.play_area_start = Vector2(0, (MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2)
	MapSettings.play_area_end = Vector2(
		MapSettings.play_area_size.x, 
		MapSettings.play_area_size.y + (
			MapSettings.total_screen.y - MapSettings.play_area_size.y
		) / 2
	)

	MapSettings.own_area_start = Vector2(
		0, MapSettings.play_area_size.y + (
			MapSettings.total_screen.y - MapSettings.play_area_size.y
			) / 2
	)
	MapSettings.own_area_end = Vector2(MapSettings.play_area_size.x, MapSettings.total_screen.y)


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
		GameManager.ps_column_row[column] = {}
		for row in map_data["Rows"]:
			var play_space: PlaySpace = play_space_scene.instantiate()
			play_space.column = column
			play_space.row = row
			play_space.name = str(n_play_spaces)

			if multiplayer.is_server():
				add_child(play_space, true)
				GameManager.play_spaces.append(play_space)
			GameManager.ps_column_row[column][row] = play_space
			n_play_spaces += 1

	for row in map_data["Rows"]:
		MapSettings.number_of_rows += 1


func _set_end_turn_button() -> void:
	$EndTurnButton.scale.x *= (MapSettings.total_screen.x / 10) / $EndTurnButton.size.x
	$EndTurnButton.scale.y *= (MapSettings.total_screen.y / 10) / $EndTurnButton.size.y
	$EndTurnButton.position.x = MapSettings.total_screen.x - MapSettings.total_screen.x / 10
	$EndTurnButton.position.y = MapSettings.total_screen.y - MapSettings.total_screen.y / 10
	MapSettings.end_turn_button_size = $EndTurnButton.size
	$EndTurnButton.text = "End your turn!"


func _set_zoom_preview_position_and_size() -> void:
	var zoom_preview_size: Vector2 = Vector2(
		MapSettings.total_screen.x * 0.2, MapSettings.total_screen.x * 0.2
	)
	$ZoomPreview.position.x = MapSettings.total_screen.x - zoom_preview_size.x
	$ZoomPreview.position.y = MapSettings.play_area_start.y
	$ZoomPreview.scale.x *= zoom_preview_size.x / $ZoomPreview.size.x
	$ZoomPreview.scale.y *= zoom_preview_size.x / $ZoomPreview.size.y
	MapSettings.zoom_preview_size = zoom_preview_size
	GameManager.zoom_preview = $ZoomPreview


func _set_resource_bars_position_and_size() -> void:
	var rb_1 = resource_bar_scene.instantiate()
	var rb_2 = resource_bar_scene.instantiate()
	
	match GameManager.is_player_1:
		true:
			rb_1.position.y = (
				MapSettings.total_screen.y - MapSettings.resource_bar_size.y 
				- MapSettings.end_turn_button_size.y
			)
			rb_2.position.y = 0
		false:
			rb_2.position.y = (
				MapSettings.total_screen.y - MapSettings.resource_bar_size.y 
				- MapSettings.end_turn_button_size.y
			)
			rb_1.position.y = 0
	
	for rb in [rb_1, rb_2]:
		rb.position.x = MapSettings.total_screen.x - MapSettings.resource_bar_size.x
		rb.scale.x *= MapSettings.resource_bar_size.x / rb.size.x
		rb.scale.y *= MapSettings.resource_bar_size.y / rb.size.y

	GameManager.resource_bar_p1 = rb_1
	GameManager.resource_bar_p2 = rb_2
	add_child(rb_1)
	add_child(rb_2)
	
