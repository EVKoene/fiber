extends Node


enum npcs {
	 HANS, JACQUES, JESUS, JOS, GARY, MASHA, ROB, GURU_FLAPPIE, GURU_TRONG, 
	GURU_KAL, GURU_LAGHIMA, 
}
enum character_types {
	 BEEBOY, BUMBLEBEE_LADY, BUSINESS_CAP_BOY, DINO_BUSINESS_MAN, ROBOT_GUY, JESUS, GARY, GURU_1,
	GURU_2, GURU_3, GURU_LAGHIMA
}
enum special_rules { ADD_1_MAX_ATTACK, ADD_1_HEALTH, }


var npc_data: Dictionary = {
	npcs.HANS: {
		"Name": "Hans",
		"Dialogue": ["You think you can handle me?", "My gorillas will fucking tear you to shreds"],
		"Battle": true,
		"CharacterModel": character_types.BEEBOY,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.GORILLA]
	},
	npcs.MASHA: {
		"Name": "Masha",
		"Dialogue": ["WOOF! WOOF!"],
		"Battle": true,
		"CharacterModel": character_types.BUMBLEBEE_LADY,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.FRENZY_START]
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
	
	### IMAGINATION DECKS ###
	npcs.JOS: {
		"Name": "Jos",
		"Dialogue": ["Let's see how well you can dance..."],
		"Battle": true,
		"CharacterModel": character_types.BUSINESS_CAP_BOY,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.IMAGINATION_MISSILES]
	},
	
	### LOGIC DECKS ###
	npcs.ROB: {
		"Name": "Rob",
		"Dialogue": ["Everyone has their part to play."],
		"Battle": true,
		"CharacterModel": character_types.ROBOT_GUY,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.LOGIC_FACTORY],
	},
	
	### GROWTH DECKS ###
	npcs.JESUS: {
		"Name": "Jesus",
		"Dialogue": ["Hi.", "I'm Jesus.", "I play some beefy boys."],
		"Battle": true,
		"CharacterModel": character_types.JESUS,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.BEEFY_BOYS],
	},
	
	npcs.GURU_FLAPPIE: {
		"Name": "Guru Flappie",
		"Dialogue": ["I'm just really into my guitar right now"],
		"Battle": true,
		"CharacterModel": character_types.GURU_1,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.BEEFY_BOYS],
	},
	
	npcs.GURU_KAL: {
		"Name": "Guru Kal",
		"Dialogue": ["I'm studying to become a guru"],
		"Battle": true,
		"CharacterModel": character_types.GURU_2,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.GOLEMS],
	},
	
	npcs.GURU_TRONG: {
		"Name": "Guru Flappie",
		"Dialogue": ["Right now right now!"],
		"Battle": true,
		"CharacterModel": character_types.GURU_3,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.ELEMENTS],
	},
	
	npcs.GURU_LAGHIMA: {
		"Name": "Guru Laghima",
		"Dialogue": ["Let go your earthly tether.", "Enter the void.", "Empty and become wind."],
		"SpecialRules": [special_rules.ADD_1_HEALTH],
		"Battle": true,
		"CharacterModel": character_types.GURU_LAGHIMA,
		"Deck": DeckCollection.decks[DeckCollection.deck_ids.GURU_LAGHIMA],
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
	character_types.GURU_1: "guru_1",
	character_types.GURU_2: "guru_2",
	character_types.GURU_3: "guru_3",
	character_types.GURU_LAGHIMA: "guru_laghima",
}


func setup_special_rules(npc_id: int) -> void:
	match npc_id:
		npcs.GARY:
			await SpecialRules.add_stat(Collections.stats.MAX_ATTACK, 1)


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

