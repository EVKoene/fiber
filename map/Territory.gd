extends Panel

class_name Territory

var owner_id: int
var play_space: PlaySpace


func _init(_owner_id: int, _play_space: PlaySpace):
	owner_id = _owner_id
	play_space = _play_space


func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size = MapSettings.play_space_size
	_set_border()
	position.x = MapSettings.get_column_start_x(play_space.column)
	position.y = MapSettings.get_row_start_y(play_space.row)
	_set_territory_borders(false)
	GameManager.territories.append(self)


func _set_border():
	var border := StyleBoxFlat.new()

	add_theme_stylebox_override("panel", border)
	get_theme_stylebox("panel").bg_color = Color("99999900")
	get_theme_stylebox("panel").set_border_width_all(MapSettings.play_space_size.x / 30)

	match owner_id:
		GameManager.p1_id:
			get_theme_stylebox("panel").border_color = Styling.p1_color
		GameManager.p2_id:
			get_theme_stylebox("panel").border_color = Styling.p2_color


func change_territory_border(direction: int, border_visible: bool) -> void:
	var border_width: float
	if border_visible:
		border_width = MapSettings.play_space_size.x / 30
	else:
		border_width = 0

	match [GameManager.player_id, direction]:
		[GameManager.p1_id, Collections.directions.UP]:
			get_theme_stylebox("panel").border_width_top = border_width
		[GameManager.p1_id, Collections.directions.RIGHT]:
			get_theme_stylebox("panel").border_width_right = border_width
		[GameManager.p1_id, Collections.directions.DOWN]:
			get_theme_stylebox("panel").border_width_bottom = border_width
		[GameManager.p1_id, Collections.directions.LEFT]:
			get_theme_stylebox("panel").border_width_left = border_width
		[GameManager.p2_id, Collections.directions.UP]:
			get_theme_stylebox("panel").border_width_bottom = border_width
		[GameManager.p2_id, Collections.directions.RIGHT]:
			get_theme_stylebox("panel").border_width_left = border_width
		[GameManager.p2_id, Collections.directions.DOWN]:
			get_theme_stylebox("panel").border_width_top = border_width
		[GameManager.p2_id, Collections.directions.LEFT]:
			get_theme_stylebox("panel").border_width_right = border_width


func _set_territory_borders(borders_visible: bool) -> void:
	for ps in play_space.adjacent_play_spaces():
		if !ps.territory:
			continue
		if ps.territory.owner_id != GameManager.player_id:
			continue

		if ps.column > play_space.column:
			change_territory_border(Collections.directions.RIGHT, borders_visible)
			ps.territory.change_territory_border(Collections.directions.LEFT, borders_visible)
		if ps.column < play_space.column:
			change_territory_border(Collections.directions.LEFT, borders_visible)
			ps.territory.change_territory_border(Collections.directions.RIGHT, borders_visible)
		if ps.row > play_space.row:
			change_territory_border(Collections.directions.DOWN, borders_visible)
			ps.territory.change_territory_border(Collections.directions.UP, borders_visible)
		if ps.row < play_space.row:
			change_territory_border(Collections.directions.UP, borders_visible)
			ps.territory.change_territory_border(Collections.directions.DOWN, borders_visible)


func disown_territory() -> void:
	_set_territory_borders(true)
	play_space.territory = null
	queue_free()
