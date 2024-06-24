extends Panel

class_name PlaySpace


@export var column: int
@export var row: int
@export var stat_modifier := {
	GameManager.p1_id: {
		Collections.stats.ATTACK: 0,
		Collections.stats.HEALTH: 0,
		Collections.stats.MOVEMENT: 0,
	},
	GameManager.p2_id: {
		Collections.stats.ATTACK: 0,
		Collections.stats.HEALTH: 0,
		Collections.stats.MOVEMENT: 0,
	},
}

var attributes: Array = []
var contest_space: bool
var border_style: StyleBox
var play_space_owner_id := -1
var card_in_this_play_space: CardInPlay


func _ready():
	scale *= MapSettings.play_space_size/size
	position = _calc_position()
	_set_play_space_attributes()
	set_border()
func set_border() -> void:
	if Collections.play_space_attributes.DRAW_CARD_SPACE in attributes:
		border_style = Styling.draw_card_space_border
	elif Collections.play_space_attributes.RESOURCE_SPACE in attributes:
		border_style = Styling.resource_space_border
	elif Collections.play_space_attributes.P1_START_SPACE in attributes:
		border_style = Styling.p1_start_space_border
	elif Collections.play_space_attributes.P2_START_SPACE in attributes:
		border_style = Styling.p2_start_space_border
	else:
		border_style = Styling.base_space_border

	add_theme_stylebox_override("panel", border_style)
	get_theme_stylebox("panel").border_width_left = size.x / 15
	get_theme_stylebox("panel").border_width_right = size.x / 15
	get_theme_stylebox("panel").border_width_top = size.y / 15
	get_theme_stylebox("panel").border_width_bottom = size.y / 15


func highlight_space():
	border_style = load("res://styling/card_borders/CardSelectedBorder.tres")
	add_theme_stylebox_override("panel", border_style)


func in_starting_area(card: CardInHand) -> bool:
	if (
		card.card_owner_id == GameManager.p1_id 
		and Collections.play_space_attributes.P1_START_SPACE in attributes
	):
		return true
	elif (
		card.card_owner_id == GameManager.p2_id 
		and Collections.play_space_attributes.P2_START_SPACE in attributes
	):
		return true
	else:
		return false


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if in_starting_area(data) and data.card_type == Collections.card_types.UNIT:
		return true
	if data.card_type == Collections.card_types.SPELL and data.can_target_unit(null):
		return true
	
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	match [GameManager.is_server, data.card_type]:
		[true, Collections.card_types.UNIT]:
			data.play_unit(column, row)
		[true, Collections.card_types.SPELL]:
			assert(false, "Playing spells not implemented yet")
		[false, Collections.card_types.UNIT]:
			data.play_unit.rpc_id(1, column, row)
		[false, Collections.card_types.SPELL]:
			assert(false, "Playing spells not implemented yet")


func _set_play_space_attributes() -> void:
	# If we want to enable multiple maps, we should load id it as an export var in this script
	attributes = MapDatabase.get_play_space_attributes(MapDatabase.maps.BASE_MAP, self)
	
	if Collections.play_space_attributes.P1_START_SPACE in attributes:
		play_space_owner_id = GameManager.p1_id
	if Collections.play_space_attributes.P2_START_SPACE in attributes:
		play_space_owner_id = GameManager.p2_id
	if (
		Collections.play_space_attributes.RESOURCE_SPACE in attributes 
		or Collections.play_space_attributes.DRAW_CARD_SPACE in attributes
		):
		GameManager.resource_spaces.append(self) 


func _set_contest_space() -> void:
	if (
		Collections.play_space_attributes.DRAW_CARD_SPACE in attributes
		or Collections.play_space_attributes.RESOURCE_SPACE in attributes
	) and play_space_owner_id == -1:
		contest_space = true


func _calc_position() -> Vector2:
	return Vector2(
		MapSettings.get_column_start_x(column), 
		MapSettings.get_row_start_y(row)
	)
