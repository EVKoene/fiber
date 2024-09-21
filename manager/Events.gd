extends Node

### BUTONS ###
signal finish_button_pressed
signal show_resolve_spell_button
signal resolve_spell_button_pressed

### INSTRUCTIONS
signal show_instructions(instruction_text: String)
signal hide_instructions

### CARD ACTIONS
signal clear_paths
signal card_discarded

### OVERWORLD ###
signal pause_player_movement
signal resume_player_movement
signal direction_changed(direction: int)
signal overworld_text_request(text: String)
signal npc_interaction_started(npc_id: int)
