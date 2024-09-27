extends Node


enum npcs {HANS, JOS}


var npc_data: Dictionary = {
	npcs.HANS: {
		"Name": "Hans",
		"Dialogue": ["You think you can handle me?", "My gorillas will fucking tear you to shreds"],
		"Battle": true,
		"CharacterType": Collections.character_types.BEEBOY,
		"Deck": DeckCollection.gorilla
	},
	npcs.JOS: {
		"Name": "Jos",
		"Dialogue": ["Let's see how well you can dance..."],
		"Battle": true,
		"CharacterType": Collections.character_types.BEEBOY,
		"Deck": DeckCollection.magic_missiles
	}
}


func npc_animation(npc: int, direction: int, animation_type: int) -> String:
	var character_type: String
	var direction_string: String
	var animation_type_string: String
	
	character_type = _character_type[npc]
	
	match direction:
		Collections.directions.UP:
			direction_string = "back"
		Collections.directions.RIGHT:
			direction_string = "side"
		Collections.directions.LEFT:
			direction_string = "side"
		Collections.directions.DOWN:
			direction_string = "front"
	
	match animation_type:
		Collections.animation_types.IDLE:
			animation_type_string = "idle"
		Collections.animation_types.WALKING:
			animation_type_string = "walking"
	
	return str(character_type, "_", direction_string, "_", animation_type_string)


var _character_type := {
	Collections.character_types.BEEBOY: "beeboy",
	Collections.character_types.BUSINESS_CAP_BOY: "business_cap_boy",
}
