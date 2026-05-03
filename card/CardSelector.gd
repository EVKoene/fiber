class_name CardSelector


var current_hovered_card: CardInHand
var current_hovered_card_index: int
var owner_id: int

func _init(_owner_id: int) -> void:
	owner_id = _owner_id
	GameManager.current_card_selector = self


func hover_next_card() -> void:
	var next_card_index = GameManager.cards_in_play[owner_id][current_hovered_card_index + 1]
	current_hovered_card.unhover()


func cleanup() -> void:
	if current_hovered_card:
		current_hovered_card.unhover()
	if GameManager.current_card_selector == self:
		GameManager.current_card_selector = null
	
