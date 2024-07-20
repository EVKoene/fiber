extends Node2D

@onready var play_space_scene: PackedScene = preload("res://map/PlaySpace.tscn")
@onready var card_scene: PackedScene = preload("res://card/CardInPlay.tscn")
@onready var resource_bar_scene: PackedScene = preload("res://player/ResourceBar.tscn")
@onready var turn_manager_scene: PackedScene = preload("res://manager/TurnManager.tscn")


var map = MapDatabase.maps.BASE_MAP
var map_data = MapDatabase.map_data[map]
var end_turn_button: Button
var instruction_container: PanelContainer
var text_box: Panel


func _ready():
	GameManager.battle_map = self
	$MultiplayerSpawner.add_spawnable_scene("res://manager/TurnManager.tscn")
	_create_battle_map()
	_set_zoom_preview_position_and_size()
	_set_end_turn_button()
	_set_resource_bars_position_and_size()
	_set_text_containers()
	_set_cards_in_play_and_hand_dicts()
	_create_progress_bars()
	_create_resources()
	if multiplayer.is_server():
		GameManager.is_server = true
		_add_turn_managers()
		# To make sure the cards and card orders are always the same for both players, we only create
		# the decks on the server
		_add_decks()
		_start_first_turn()


func show_text(text_to_show: String) -> void:
	$TextBox/Panel/Label.text = text_to_show
	$TextBox.show()


func _start_first_turn() -> void:
	var first_player_id = [GameManager.p1_id, GameManager.p2_id].pick_random()
	GameManager.turn_manager.hide_end_turn_button.rpc_id(
		GameManager.opposing_player_id(first_player_id)
	)
	GameManager.turn_manager.show_start_turn_text.rpc_id(first_player_id)


func _add_decks() -> void:
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		var deck_data: Dictionary = GameManager.players[p_id]["Deck"]
		GameManager.decks[p_id] = Deck.new(p_id, deck_data["Cards"], deck_data["StartingCards"])
		add_child(GameManager.decks[p_id])


func _add_turn_managers() -> void:
	var turn_manager = turn_manager_scene.instantiate()
	add_child(turn_manager, true)


func _create_battle_map() -> void:
	MapSettings.n_progress_bars = map_data["SpacesToWin"]
	_set_area_sizes()
	_set_play_space_size()
	_create_play_spaces()


func _set_area_sizes() -> void:
	MapSettings.play_area_size = MapSettings.total_screen * Vector2(0.8, 0.9)
	MapSettings.opponent_area_start = Vector2(0, 0)
	MapSettings.opponent_area_end = Vector2(
		MapSettings.play_area_size.x, (
			MapSettings.total_screen.y - MapSettings.play_area_size.y
			) / 2
	)
	
	MapSettings.play_area_start = Vector2(0, (MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2)
	MapSettings.play_area_end = Vector2(
		MapSettings.play_area_size.x, 
		MapSettings.play_area_size.y + (
			MapSettings.total_screen.y - MapSettings.play_area_size.y
		) / 2
	)
	
	MapSettings.own_area_start = Vector2(
		0, MapSettings.play_area_size.y + (
			MapSettings.total_screen.y - MapSettings.play_area_size.y
			) / 2
	)
	MapSettings.own_area_end = Vector2(MapSettings.play_area_size.x, MapSettings.total_screen.y)


func _set_play_space_size() -> void:
	var min_column_length: float = MapSettings.play_area_size.x / float(map_data["Columns"])
	var min_row_length: float = MapSettings.play_area_size.y / float(map_data["Rows"])
	
	var ps_size: int = min(min_column_length, min_row_length)

	MapSettings.play_space_size = Vector2(ps_size, ps_size)
	# TODO: Calculate an exact size based on borderwidth of playspace and card border
	MapSettings.card_in_play_size = Vector2(ps_size, ps_size) * 0.9


func _create_play_spaces() -> void:
	MapSettings.n_columns = map_data["Columns"]
	MapSettings.n_rows = map_data["Rows"]
	for column in map_data["Columns"]:
		GameManager.ps_column_row[column] = {}
		for row in map_data["Rows"]:
			var play_space: PlaySpace = play_space_scene.instantiate()
			play_space.column = column
			play_space.row = row
			add_child(play_space)
			MapSettings.play_spaces.append(play_space)
			

func _set_end_turn_button() -> void:
	$EndTurnButton.scale.x *= (MapSettings.total_screen.x / 10) / $EndTurnButton.size.x
	$EndTurnButton.scale.y *= (MapSettings.total_screen.y / 10) / $EndTurnButton.size.y
	$EndTurnButton.position.x = MapSettings.total_screen.x - MapSettings.total_screen.x / 10
	$EndTurnButton.position.y = MapSettings.total_screen.y - MapSettings.total_screen.y / 10
	MapSettings.end_turn_button_size = $EndTurnButton.size
	$EndTurnButton.text = "End your turn!"
	end_turn_button = $EndTurnButton


func _set_zoom_preview_position_and_size() -> void:
	var zoom_preview_size: Vector2 = Vector2(
		MapSettings.total_screen.x * 0.2, MapSettings.total_screen.x * 0.2
	)
	# Multiplying the zoom_preview_size.x with 1.1 to adjust for border size
	$ZoomPreview.position.x = MapSettings.total_screen.x - zoom_preview_size.x * 1.05 
	$ZoomPreview.position.y = MapSettings.play_area_start.y
	$ZoomPreview.scale.x *= zoom_preview_size.x / $ZoomPreview.size.x
	$ZoomPreview.scale.y *= zoom_preview_size.x / $ZoomPreview.size.y
	MapSettings.zoom_preview_size = zoom_preview_size
	GameManager.zoom_preview = $ZoomPreview


func _set_resource_bars_position_and_size() -> void:
	var rb_1 = resource_bar_scene.instantiate()
	var rb_2 = resource_bar_scene.instantiate()
	
	match GameManager.is_player_1:
		true:
			rb_1.position.y = (
				MapSettings.total_screen.y - MapSettings.resource_bar_size.y 
				- MapSettings.end_turn_button_size.y
			)
			rb_2.position.y = 0
		false:
			rb_2.position.y = (
				MapSettings.total_screen.y - MapSettings.resource_bar_size.y 
				- MapSettings.end_turn_button_size.y
			)
			rb_1.position.y = 0
	
	for rb in [rb_1, rb_2]:
		rb.position.x = MapSettings.total_screen.x - MapSettings.resource_bar_size.x
		rb.scale.x *= MapSettings.resource_bar_size.x / rb.size.x
		rb.scale.y *= MapSettings.resource_bar_size.y / rb.size.y

	GameManager.resource_bars[GameManager.p1_id] = rb_1
	GameManager.resource_bars[GameManager.p2_id] = rb_2
	add_child(rb_1)
	add_child(rb_2)


func _create_progress_bars() -> void:
	GameManager.progress_bars[GameManager.p1_id] = []
	GameManager.progress_bars[GameManager.p2_id] = []
	
	# In the future we probably want players to get all resource spaces on their half + the ones
	# center. For now it's total number / 2 however.
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		for b in MapSettings.n_progress_bars:
			var progress_bar = ProgressBar.new()
			var progress_bar_y_size = MapSettings.play_space_size.y / MapSettings.n_progress_bars
			add_child(progress_bar)
			progress_bar.custom_minimum_size.x = MapSettings.play_space_size.x / 4
			progress_bar.custom_minimum_size.y = progress_bar_y_size
			progress_bar.position.x = MapSettings.play_area_size.x + b * progress_bar_y_size
			progress_bar.rotation_degrees = 90
			progress_bar.show_percentage = false
			var sb = StyleBoxFlat.new()
			progress_bar.add_theme_stylebox_override("fill", sb)
			GameManager.progress_bars[p_id].append(progress_bar)
			match [GameManager.is_player_1, p_id]:
				[true, GameManager.p1_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 + progress_bar.size.y
					sb.bg_color = Color.hex(0x3b3be7dc)
				[true, GameManager.p2_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 - progress_bar.size.y
					sb.bg_color = Color.hex(0xf3131edc)
				[false, GameManager.p1_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 - progress_bar.size.y
					sb.bg_color = Color.hex(0x3b3be7dc)
				[false, GameManager.p2_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 + progress_bar.size.y
					sb.bg_color = Color.hex(0xf3131edc)


func _set_text_containers() -> void:
	$InstructionContainer.scale.x *= (MapSettings.play_space_size.x * 2) / $InstructionContainer.size.x
	$InstructionContainer.scale.y *= (MapSettings.total_screen.y / 5) / $InstructionContainer.size.y
	$InstructionContainer.position.x = MapSettings.total_screen.x - MapSettings.play_space_size.x * 2
	$InstructionContainer.position.y = MapSettings.total_screen.y * 0.6
	instruction_container = $InstructionContainer
	
	$TextBox.scale *= MapSettings.total_screen / $TextBox.size
	text_box = $TextBox


func _set_cards_in_play_and_hand_dicts() -> void:
	GameManager.cards_in_hand[GameManager.p1_id] = []
	GameManager.cards_in_play[GameManager.p1_id] = []
	GameManager.cards_in_hand[GameManager.p2_id] = []
	GameManager.cards_in_play[GameManager.p2_id] = []


func _on_end_turn_button_pressed():
	GameManager.turn_manager.end_turn.rpc_id(GameManager.p1_id, GameManager.player_id)


func _create_resources():
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		var resources := Resources.new(p_id)
		GameManager.resources[p_id] = resources
		add_child(resources)


func _input(_event):
	if (
		(
			Input.is_action_just_pressed("ui_accept") 
			or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		)
		and GameManager.turn_manager.can_start_turn
	):
		GameManager.turn_manager.can_start_turn = false
		$TextBox.hide()
		GameManager.turn_manager.start_turn.rpc_id(GameManager.p1_id, GameManager.player_id)
