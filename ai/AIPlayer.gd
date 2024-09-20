extends Node

class_name AIPlayer


var ai_turn_manager: AITurnManager
var player_id: int
var playing_cards := false
var moving_cards := false
var turn_finished := false


func play_turn() -> void:
	await play_playable_cards()
	await GameManager.battle_map.get_tree().create_timer(0.5).timeout
	ai_turn_manager.end_turn()


func discard_card() -> void:
	var card: CardInHand
	card = GameManager.cards_in_hand[player_id].picK_random
	card.discard()


func play_playable_cards() -> void:
	playing_cards = true
	while playing_cards:
		playing_cards = false
		for c in GameManager.cards_in_hand[player_id]:
			if (
				GameManager.resources[player_id].can_pay_costs(c.costs) 
				and c.card_type == Collections.card_types.UNIT
			):
				playing_cards = await play_card(c)


func play_card(card: CardInHand) -> bool:
	await GameManager.battle_map.get_tree().create_timer(0.5).timeout
	var ps_options := []
	for ps in GameManager.play_spaces:
		if !ps.territory:
			continue
		if !ps.card_in_this_play_space and ps.territory.owner_id == player_id:
			ps_options.append(ps)
	
	if len(ps_options) == 0:
		return false
	
	var play_space: PlaySpace = ps_options.pick_random()
	BattleManager.play_unit(card.card_index, player_id, play_space.column, play_space.row)
	BattleManager.remove_card_from_hand(player_id, card.hand_index)
	return true
