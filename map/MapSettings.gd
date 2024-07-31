extends Node

@onready var total_screen: Vector2 = Vector2(get_viewport().size)
@onready var resource_bar_size := Vector2(total_screen.x * 0.2, total_screen.y * 0.05)

var play_area_start: Vector2
var play_area_end: Vector2
var own_area_start: Vector2
var own_area_end: Vector2
var opponent_area_start: Vector2
var opponent_area_end: Vector2
var play_area_size: Vector2
var play_space_size: Vector2
var card_in_play_size: Vector2
var n_columns: int
var n_rows: int
var zoom_preview_size := Vector2(200, 200)
var end_turn_button_size: Vector2
var n_progress_bars: int


func get_column_start_x(column) -> float:
	if GameManager.is_player_1:
		return MapSettings.play_area_start.x + MapSettings.play_space_size.x * column
	else:
		return (
			MapSettings.play_area_start.x + 
			MapSettings.play_space_size.x * MapSettings.n_columns
			- MapSettings.play_space_size.x * (column + 1)
		)


func get_row_start_y(row) -> float:
	if multiplayer.is_server():
		return MapSettings.play_area_start.y + MapSettings.play_space_size.y * row
	else:
		return (
			MapSettings.play_area_start.y + 
			MapSettings.play_space_size.y * MapSettings.n_rows
			- MapSettings.play_space_size.y * (row + 1)
		)


func get_column_end_x(column) -> float:
	if multiplayer.get_unique_id() == GameManager.p1_id:
		return MapSettings.play_area_start.x + MapSettings.play_space_size.x * (column + 1)
	else:
		return (
			MapSettings.play_area_start.x + 
			MapSettings.play_space_size.x * MapSettings.n_columns
			- MapSettings.play_space_size.x * column
		)

func get_row_end_y(row) -> float:
	if multiplayer.get_unique_id() == GameManager.p1_id:
		return MapSettings.play_area_start.y + MapSettings.play_space_size.y * (row + 1)
	else:
		return (
			MapSettings.play_area_start.y + 
			MapSettings.play_space_size.y * MapSettings.n_rows
			- MapSettings.play_space_size.y * row
		)
