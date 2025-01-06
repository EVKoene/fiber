extends Node
"""
NOTE: We're ignoring all unused signals in this script due to an outdated way of using signals.
TODO: Improve this, probably by only emitting and connecting function specific signals
"""
### BUTONS ###
@warning_ignore("unused_signal") 
signal finish_button_pressed
@warning_ignore("unused_signal") 
signal show_resolve_spell_button
@warning_ignore("unused_signal") 
signal resolve_spell_button_pressed

### INSTRUCTIONS
@warning_ignore("unused_signal") 
signal show_instructions(instruction_text: String)
@warning_ignore("unused_signal") 
signal hide_instructions
@warning_ignore("unused_signal") 
signal instruction_input_received
@warning_ignore("unused_signal") 
signal prompt_answer_positive(positive: bool)

### CARD ACTIONS
@warning_ignore("unused_signal") 
signal clear_paths
@warning_ignore("unused_signal") 
signal card_discarded

### AI ###
@warning_ignore("unused_signal") 
signal spell_resolved_for_ai
@warning_ignore("unused_signal") 
signal card_ability_resolved_for_ai

### OVERWORLD ###
@warning_ignore("unused_signal") 
signal pause_player_movement
@warning_ignore("unused_signal") 
signal resume_player_movement
@warning_ignore("unused_signal") 
signal direction_changed(direction: int)
@warning_ignore("unused_signal") 
signal overworld_text_request(text: String)
@warning_ignore("unused_signal") 
signal npc_interaction_started(npc_id: int)
@warning_ignore("unused_signal") 
signal dialogue_finished
