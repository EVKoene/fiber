extends Node


enum npcs { HANS, JACQUES, JESUS, JOS, GARY, MASHA, ROB }
enum character_types {
	 BEEBOY, BUMBLEBEE_LADY, BUSINESS_CAP_BOY, DINO_BUSINESS_MAN, ROBOT_GUY, JESUS, GARY, 
}
enum special_rules { ADD_1_MAX_ATTACK, }


var npc_data: Dictionary = {
	npcs.HANS: {
		"Name": "Hans",
		"Dialogue": ["You think you can handle me?", "My gorillas will fucking tear you to shreds"],
		"Battle": true,
		"CharacterModel": character_types.BEEBOY,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.GORILLA]
	},
	npcs.JOS: {
		"Name": "Jos",
		"Dialogue": ["Let's see how well you can dance..."],
		"Battle": true,
		"CharacterModel": character_types.BUSINESS_CAP_BOY,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.IMAGINATION_MISSILES]
	},
	npcs.MASHA: {
		"Name": "Masha",
		"Dialogue": ["WOOF! WOOF!"],
		"Battle": true,
		"CharacterModel": character_types.BUMBLEBEE_LADY,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.FRENZY_START]
	},
	npcs.ROB: {
		"Name": "Rob",
		"Dialogue": ["Everyone has their part to play."],
		"Battle": true,
		"CharacterModel": character_types.ROBOT_GUY,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.LOGIC_FACTORY],
	},
	npcs.JESUS: {
		"Name": "Jesus",
		"Dialogue": ["Hi.", "I'm Jesus.", "I play some beefy boys."],
		"Battle": true,
		"CharacterModel": character_types.JESUS,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.BEEFY_BOYS],
	},
	npcs.JACQUES: {
		"Name": "Jacques",
		"Dialogue": ["Ew, what's that smell?", "Oh, it's me."],
		"Battle": true,
		"CharacterModel": character_types.DINO_BUSINESS_MAN,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.SMELLY_JACQUES],
	},
	npcs.GARY: {
		"Name": "Gary",
		"Dialogue": ["Bring it on bitch"],
		"SpecialRules": [special_rules.ADD_1_MAX_ATTACK],
		"Battle": true,
		"CharacterModel": character_types.GARY,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.MINIBOSS],
	},
}

var character_model := {
	character_types.BEEBOY: "beeboy",
	character_types.BUMBLEBEE_LADY: "bumblebee_lady",
	character_types.BUSINESS_CAP_BOY: "business_cap_boy",
	character_types.DINO_BUSINESS_MAN: "dino_business_man",
	character_types.GARY: "gary",
	character_types.ROBOT_GUY: "robot_guy",
	character_types.JESUS: "jesus",
}


func setup_special_rules(npc_id: int) -> void:
	match npc_id:
		npcs.GARY:
			SpecialRules.add_stat(Collections.stats.MAX_ATTACK, 1)


func npc_animation(npc: int, direction: int, animation_type: int) -> String:
	var character_type: String
	var direction_string: String
	var animation_type_string: String
	
	character_type = character_model[npc_data[npc]["CharacterModel"]]
	
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

