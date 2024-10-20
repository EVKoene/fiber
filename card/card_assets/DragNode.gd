extends Control


var card_index: int
var img_path: String
var card_in_hand: CardInHand
var card_owner_id: int


func _get_drag_data(at_position: Vector2) -> CardInHand:
	if !is_playable():
		return null
	
	var card_preview: TextureRect = TextureRect.new()
	card_preview.texture = load(img_path)
	card_preview.set_size(MapSettings.play_space_size) 
	card_preview.scale *= MapSettings.play_space_size / card_preview.size
	
	card_preview.position = at_position
	set_drag_preview(card_preview)
		
	return card_in_hand


func is_playable() -> bool:
	if card_owner_id != GameManager.player_id:
		return false
	if !GameManager.resources[card_owner_id].can_pay_costs(card_in_hand.costs):
		return false
	if !GameManager.turn_manager.turn_actions_enabled:
		return false
	if GameManager.turn_manager.turn_owner_id != GameManager.player_id:
		return false
	
	return true
