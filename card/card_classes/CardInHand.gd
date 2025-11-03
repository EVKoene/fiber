extends Card

class_name CardInHand

var attack_range: int
var card_range: int
var max_attack: int
var min_attack: int
var movement: int
var health: int
var shield: int
var hand_index: int:
	get = _get_hand_index


func _ready():
	card_class = Collections.card_classes.CARD_IN_HAND
	GameManager.cards_in_hand[card_owner_id].append(self)
	load_card_properties()
	set_card_position()
	set_card_size()
	_set_drag_node_properties()
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_ADDED_TO_HAND, self)


func discard() -> void:
	var h_index := hand_index
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_DISCARDED, null)
	if GameManager.is_single_player:
		BattleSynchronizer.remove_card_from_hand(card_owner_id, h_index)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.remove_card_from_hand.rpc_id(p_id, card_owner_id, h_index)
	Events.card_discarded.emit()


func play_spell(column: int, row: int) -> void:
	if GameManager.is_single_player:
		BattleSynchronizer.lock_zoom_preview_hand(card_owner_id, hand_index)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleSynchronizer.lock_zoom_preview_hand.rpc_id(p_id, card_owner_id, hand_index)

	GameManager.battle_map.create_card_resolve(card_owner_id, hand_index, column, row)


func set_card_position() -> void:
	position.x = (
		GameManager.cards_in_hand[card_owner_id].find(self)
		* ((MapSettings.own_area_end.x - MapSettings.own_area_start.x) / 7)
	)
	
	if card_owner_id not in [GameManager.p1_id, GameManager.p2_id]:
		assert(false, str("Card owner id not recognized: ", str(card_owner_id)))
	
	match [GameManager.is_player_1, card_owner_id]:
		[true, GameManager.p1_id]:
			position.y = MapSettings.own_area_start.y
		[true, GameManager.p2_id]:
			position.y = MapSettings.opponent_area_start.y
		[false, GameManager.p2_id]:
			position.y = MapSettings.own_area_start.y
		[false, GameManager.p1_id]:
			position.y = MapSettings.opponent_area_start.y


func set_card_size() -> void:
	scale.x *= MapSettings.card_in_hand_size.x / size.x
	scale.y *= MapSettings.card_in_hand_size.y / size.y


func _set_drag_node_properties() -> void:
	$DragNode.img_path = img_path
	$DragNode.card_index = card_index
	$DragNode.card_in_hand = self
	$DragNode.card_owner_id = card_owner_id


func _on_mouse_entered():
	if Tutorial.next_phase == Tutorial.tutorial_phases.PREVIEW_CARD:
		GameManager.zoom_preview.preview_hand_card(self, true)
		Tutorial.continue_tutorial()
		return
	GameManager.zoom_preview.preview_hand_card(self, false)
	highlight_card()


func _on_mouse_exited():
	hide_border()


func _gui_input(event):
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
		and TargetSelection.discarding
	):
		discard()


func _get_hand_index() -> int:
	return GameManager.cards_in_hand[card_owner_id].find(self)
