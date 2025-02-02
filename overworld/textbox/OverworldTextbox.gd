extends CanvasLayer

class_name OverworldTextbox

const CHAR_READ_RATE = 0.05

@onready var textbox_container := $TextboxContainer
@onready var label := $TextboxContainer/MarginContainer/HBoxContainer/Text
@onready var continue_symbol := $TextboxContainer/MarginContainer/HBoxContainer/ContinueSymbol
var tween: Tween

var current_state := State.READY
var text_queue := []
var stay_in_overworld := false
var question := false
var question_options := []
var picking_option := false

enum State { READY, READING, FINISHED }


func _ready():
	OverworldManager.overworld_textbox = self
	_hide_textbox()


func read_text(text_to_read: Array, is_question := false, options := []) -> void:
	_show_textbox()
	OverworldManager.can_move = false
	question = is_question
	question_options = options
	for t in text_to_read:
		_queue_text(t)


func _process(_delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				_display_text()
			else:
				Events.dialogue_finished.emit()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1.0
				tween.stop()
				continue_symbol.show()
				_change_state(State.FINISHED)
		State.FINISHED:
			if question:
				if !text_queue.is_empty():
					if Input.is_action_just_pressed("ui_accept"):
						_change_state(State.READY)
				else:
					if picking_option:
						return
					else:
						picking_option = true
						OverworldManager.mc_question_textbox.pick_from_options(question_options)
						await OverworldManager.mc_question_textbox.option_picked

			elif Input.is_action_just_pressed("ui_accept"):
				cleanup_textbox()
				if stay_in_overworld:
					OverworldManager.can_move = true


func _display_text() -> void:
	_show_textbox()
	var next_text: String = text_queue.pop_front()
	if tween:
		tween.kill()
	tween = create_tween()
	label.visible_ratio = 0.0
	label.text = next_text
	_change_state(State.READING)
	tween.tween_property(label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)
	tween.tween_callback(_finish_reading)


func _queue_text(next_text) -> void:
	text_queue.push_back(next_text)


func _finish_reading() -> void:
	_show_continue_symbol()
	_change_state(State.FINISHED)


func cleanup_textbox() -> void:
	_change_state(State.READY)
	stay_in_overworld = false
	question = false
	question_options = []
	picking_option = false
	_hide_textbox()


func _change_state(next_state: State) -> void:
	current_state = next_state


func _hide_textbox() -> void:
	continue_symbol.hide()
	label.text = ""
	textbox_container.hide()


func _show_textbox() -> void:
	textbox_container.show()


func _show_continue_symbol() -> void:
	continue_symbol.show()
