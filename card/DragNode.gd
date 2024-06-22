extends Control


var card_index: int
var img_path: String
var card_in_hand: CardInHand
var card_owner_id: int


func _get_drag_data(at_position: Vector2) -> CardInHand:
	if card_owner_id != GameManager.player_id:
		return null
	
	var card_preview: TextureRect = TextureRect.new()
	card_preview.texture = load(img_path)
	card_preview.set_size(MapSettings.play_space_size) 
	card_preview.scale *= MapSettings.play_space_size / card_preview.size
	
	card_preview.position = at_position
	set_drag_preview(card_preview)
		
	return card_in_hand
