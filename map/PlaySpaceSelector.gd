class_name PlaySpaceSelector

var open_space: bool
var territory_owned_by: int # Either a player id or -1 if it does not need to be owned
var spaces_to_select_from: Array[PlaySpace]
var current_hovered_play_space: PlaySpace

func _init(_open_space: bool, _territory_owned_by: int) -> void:
	open_space = _open_space
	territory_owned_by = _territory_owned_by
	GameManager.current_play_space_selector = self
	_add_spaces()
	_hover_first_play_space()


func _add_spaces() -> void:
	for ps in GameManager.play_spaces:
		if open_space and ps.card_in_this_play_space:
			continue
		if territory_owned_by != -1 and territory_owned_by != ps.territory.owner_id:
			continue
		spaces_to_select_from.append(ps)


func _hover_first_play_space() -> void:
	current_hovered_play_space = spaces_to_select_from[0]
	current_hovered_play_space.hover()


func cleanup() -> void:
	if current_hovered_play_space:
		current_hovered_play_space.unhover()
	spaces_to_select_from.clear()
	if GameManager.current_play_space_selector == self:
		GameManager.current_play_space_selector = null
