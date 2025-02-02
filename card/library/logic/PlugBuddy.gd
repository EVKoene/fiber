extends CardInPlay

class_name PlugBuddy


func _init() -> void:
	abilities = [
		{
			"FuncName": "refresh_units",
			"FuncText": "Refresh units",
			"AbilityCosts": Costs.new(0, 0, 0, 2),
		}
	]


func refresh_units() -> void:
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			continue
		if ps.card_in_this_play_space.card_owner_id == card_owner_id:
			ps.card_in_this_play_space.refresh()

	exhaust()
