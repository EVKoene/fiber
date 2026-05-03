extends Node


func burn_play_space(
	ps: PlaySpace, damage: int, controlling_player_id := -1, is_only_damaging_enemy := false
) -> void:
	if GameManager.is_single_player:
		BattleAnimation.play_burn_animation(ps.column, ps.row)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleAnimation.play_burn_animation.rpc_id(p_id, ps.column, ps.row)

	var play_space: PlaySpace = GameManager.ps_column_row[ps.column][ps.row]
	if play_space.card_in_this_play_space:
		if (
			is_only_damaging_enemy 
			and play_space.card_in_this_play_space.card_owner_id == controlling_player_id
		):
			return
		else:
			play_space.card_in_this_play_space.resolve_damage(damage)
