extends Panel


class_name CardResolve

@onready var zoom_preview_scene := load("res://battle/player/ZoomPreview.tscn")
@onready var card_resolve_scene := load("res://battle/card/card_states/CardResolve.tscn")
var ai_player := false
var card_index: int
var card_in_hand_index
var column: int
var row: int
var card_owner_id: int
var resolved := false


func _ready():
	var preview = zoom_preview_scene.instantiate()
	$CenterContainer.add_child(preview)
	preview.custom_minimum_size = MapSettings.card_in_play_size * 3 
	preview.preview_card_index(card_index, true)


func continue_resolve() -> void:
	if ai_player:
		_resolve_spell_for_ai()
		queue_free()
		return
	
	if GameManager.is_single_player:
		BattleSynchronizer.resolve_spell(card_owner_id, card_in_hand_index)
		queue_free()
		return
	
	var opposing_player_id: int = GameManager.opposing_player_id(GameManager.player_id)
	if card_owner_id != GameManager.player_id:
		BattleSynchronizer.resolve_spell.rpc_id(
			opposing_player_id, card_owner_id, card_in_hand_index
		)
		queue_free()
		return
	
	GameManager.battle_map.show_text("Wait for other player to resolve spell")
	GameManager.battle_map.create_card_resolve.rpc_id(
		opposing_player_id, card_owner_id, card_in_hand_index, column, row
	)
	queue_free()


func _resolve_spell_for_ai() -> void:
	var spell: CardInPlay = CardDatabase.get_card_class(card_index).new()
	spell.card_owner_id = card_owner_id
	await spell.resolve_spell_for_ai()
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.SPELL_PLAYED, spell)
	queue_free()



func _input(_event):
	if (
		Input.is_action_just_pressed("ui_accept") 
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	):
		if !resolved:
			resolved = true
			continue_resolve()
