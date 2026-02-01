extends CardInPlay

class_name DinosaurEgg


var turns_until_dino := 2
var dino_timer: Label


func enter_battle() -> void:
	create_dino_timer()

func call_triggered_funcs(trigger: int, _card: Card) -> void:
	if (
		trigger == Collections.triggers.TURN_STARTED 
		and GameManager.turn_manager.turn_owner_id == card_owner_id
	):
		turns_until_dino -= 1
		if turns_until_dino <= 0:
			hatch_dinosaur()
		
		set_dino_timer()


func hatch_dinosaur() -> void:
	BattleSynchronizer.play_unit(CardDatabase.cards.DINOSAUR, card_owner_id, column, row)
	GameManager.cards_in_play[card_owner_id].erase(self)
	queue_free()


func create_dino_timer() -> void:
	dino_timer = Label.new()
	dino_timer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dino_timer.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	dino_timer.text = str(turns_until_dino)
	dino_timer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dino_timer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dino_timer.add_theme_color_override("font_color", Color.BLUE)
	dino_timer.add_theme_font_size_override("font_size", 50)
	add_child(dino_timer)


func set_dino_timer() -> void:
	dino_timer.text = str(turns_until_dino)
