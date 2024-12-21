extends Node

var cards = load("res://battle/card/CardDatabase.gd").cards
enum deck_ids {
	PASSION_STARTER, IMAGINATION_STARTER, GROWTH_STARTER, LOGIC_STARTER, GORILLA,
	IMAGINATION_MISSILES, LOGIC_FACTORY, GOLEMS, ELEMENTS, BEEFY_BOYS, FRENZY_START, TUTORIAL_DECK, 
	OPPONENT_TESTING, PLAYER_TESTING, SMELLY_JACQUES, MINIBOSS 
	}


var decks := {
	deck_ids.PASSION_STARTER: {
		"DeckName": "PassionStarter",
		"Cards": {
			cards.GORILLA: 8, 
			cards.ATTACK_COMMAND: 4, 
			cards.GOOSE: 8, 
			cards.GORILLA_BATTLECALLER: 4, 
			cards.FOLLOW_PHEROMONES: 4, 
			cards.FELOS_EXPEDITIONIST: 2, 
		},
		"StartingCards": {
			cards.GORILLA: 2,
			cards.GOOSE: 1,
		},
		"ID": deck_ids.PASSION_STARTER,
	},

	deck_ids.IMAGINATION_STARTER: {
		"DeckName": "ImaginationStarter",
		"Cards": {
			cards.WIZARD_SCOUT: 8,
			cards.ARCANE_ARROW: 4, 
			cards.MIST_CONJURER: 8, 
			cards.EPHEMERAL_ASSASSIN: 4, 
			cards.HOMUNCULUS: 4, 
			cards.JELLYFISH_EXTRAORDINAIRE: 2, 
		},
		"StartingCards": {
			cards.WIZARD_SCOUT: 2,
			cards.ARCANE_ARROW: 1,
		},
		"ID": deck_ids.IMAGINATION_STARTER,
	},

	deck_ids.GROWTH_STARTER: {
		"DeckName": "GrowthStarter",
		"Cards": {
			cards.GNOME_PROTECTOR: 8,  
			cards.MORNING_LIGHT: 4, 
			cards.ICE_GOLEM: 8, 
			cards.EARTH_GOLEM: 4, 
			cards.PROTECTOR_OF_THE_FOREST: 4, 
			cards.HEART_OF_THE_FOREST: 2, 
		},
		"StartingCards": {
			cards.GNOME_PROTECTOR: 2,
			cards.BOTANO_GARDENER: 1,
		},
		"ID": deck_ids.GROWTH_STARTER,
	},

	deck_ids.LOGIC_STARTER: {
		"DeckName": "LogicStarter",
		"Cards": {
			cards.ASSEMBLY_BOT: 8, 
			cards.FACTORY_WORKER: 4, 
			cards.NETWORK_FEEDER: 8, 
			cards.FURNACE_BOT: 4, 
			cards.EXTERMINATE: 4, 
			cards.COMPUTING_BOT: 2, 
		},
		"StartingCards":  {
			cards.ASSEMBLY_BOT: 2,
			cards.FACTORY_WORKER: 1,
		},
		"ID": deck_ids.LOGIC_STARTER,
	},

	deck_ids.GORILLA: {
		"DeckName": "Gorilla",
		"Cards": {
			cards.GORILLA: 20,
			cards.GORILLA_BATTLECALLER: 10,
			cards.GORILLA_KING: 20,
		},
		"StartingCards": {
			cards.GORILLA: 3,
		},
		"ID": deck_ids.GORILLA,
	},

	deck_ids.IMAGINATION_MISSILES: {
		"DeckName": "ImaginationMissiles",
		"Cards": {
			cards.WIZARD_SCOUT: 15,
			cards.ARCANE_ARROW: 10,
			cards.FIREBALL_SHOOTER: 15,
			cards.JELLYFISH_EXTRAORDINAIRE: 5,
		},
		"StartingCards": {
			cards.WIZARD_SCOUT: 2,
			cards.ARCANE_ARROW: 1,
		},
		"ID": deck_ids.IMAGINATION_MISSILES,
	},

	deck_ids.LOGIC_FACTORY: {
		"DeckName": "Logic Factory",
		"Cards": {
			cards.ASSEMBLY_BOT: 15, 
			cards.NETWORK_FEEDER: 15, 
			cards.FURNACE_BOT: 5,
			cards.COMPUTING_BOT: 5 
		},
		"StartingCards": {
			cards.ASSEMBLY_BOT: 3,
		},
		"ID": deck_ids.LOGIC_FACTORY,
	},

	deck_ids.BEEFY_BOYS: {
		"DeckName": "Beefy Boys",
		"Cards": {
			cards.GNOME_PROTECTOR: 10,  
			cards.MORNING_LIGHT: 15, 
			cards.EARTH_GOLEM: 15, 
			cards.HEART_OF_THE_FOREST: 5, 
		},
		"StartingCards": {
			cards.GNOME_PROTECTOR: 2,
			cards.MORNING_LIGHT: 1,
		},
		"ID": deck_ids.BEEFY_BOYS,
	},

	deck_ids.GOLEMS: {
		"DeckName": "Golems",
		"Cards": {
			cards.ICE_GOLEM: 20, 
			cards.FIRE_GOLEM: 15,  
			cards.EARTH_GOLEM: 15, 
		},
		"StartingCards": {
			cards.GNOME_PROTECTOR: 3,
		},
		
		"ID": deck_ids.GOLEMS,
	},

	deck_ids.ELEMENTS: {
		"DeckName": "Elements",
		"Cards": {
			cards.BOTANO_GARDENER: 5,
			cards.WIND_GOLEM: 10,
			cards.HAIL_STORM: 15, 
			cards.EARTH_GOLEM: 10,
			cards.VOLCANIC_ERUPTION: 10, 
		},
		"StartingCards": {
			cards.GNOME_PROTECTOR: 1,
			cards.WIND_GOLEM: 2,
		},
		
		"ID": deck_ids.ELEMENTS,
	},

	deck_ids.FRENZY_START: {
		"DeckName": "Frenzy Start",
		"Cards": {
			cards.FANATIC_FOLLOWER: 15,  
			cards.WARTHOG_BERSERKER: 15, 
			cards.SKON_INSECT_FATHER: 10, 
		},
		"StartingCards": {
			cards.FANATIC_FOLLOWER: 2,
			cards.WARTHOG_BERSERKER: 1,
		},
		"ID": deck_ids.FRENZY_START,
	},

	deck_ids.SMELLY_JACQUES: {
		"DeckName": "Smelly Jacques",
		"Cards": {
			cards.SNEK: 15,  
			cards.FOLLOW_PHEROMONES: 10, 
			cards.FELOS_EXPEDITIONIST: 10, 
		},
		"StartingCards": {
			cards.GORILLA: 2,
			cards.SNEK: 1,
		},
		"ID": deck_ids.SMELLY_JACQUES,
	},
	

	deck_ids.MINIBOSS: {
		"DeckName": "Miniboss",
		"Cards": {
			cards.GORILLA: 5,
			cards.ATTACK_COMMAND: 5,
			cards.GOOSE: 10,  
			cards.FOLLOW_PHEROMONES: 10, 
			cards.FELOS_EXPEDITIONIST: 10, 
		},
		"StartingCards": {
			cards.GORILLA: 2,
			cards.GOOSE: 1,
		},
		"ID": deck_ids.MINIBOSS,
	},


	deck_ids.TUTORIAL_DECK: {
		"DeckName": "Tutorial Deck",
		"Cards": {
			cards.GORILLA: 30, 
		},
		"StartingCards": {
			cards.GORILLA: 3,
		},
		"ID": deck_ids.TUTORIAL_DECK,
	},

	deck_ids.OPPONENT_TESTING: {
		"DeckName": "Opponent testing",
		"Cards": {
			cards.GORILLA: 4, 
			cards.GOOSE: 4, 
			cards.WARTHOG_BERSERKER: 4, 
			cards.GORILLA_BATTLECALLER: 2, 
			cards.SNEK: 2, 
			cards.FELOS_EXPEDITIONIST: 3,
		},
		"StartingCards": {
			cards.GORILLA: 2,
		},
		"ID": deck_ids.OPPONENT_TESTING,
	},

	deck_ids.PLAYER_TESTING: {
		"DeckName": "Player testing",
		"Cards": {
			cards.GORILLA: 10,
		},
		"StartingCards": {
			cards.GORILLA_KING: 3
		},
		"ID": deck_ids.PLAYER_TESTING,
	},
}


var starter_decks := {
	deck_ids.PASSION_STARTER: decks[deck_ids.PASSION_STARTER],
	deck_ids.IMAGINATION_STARTER: decks[deck_ids.IMAGINATION_STARTER],
	deck_ids.GROWTH_STARTER: decks[deck_ids.GROWTH_STARTER],
	deck_ids.LOGIC_STARTER: decks[deck_ids.LOGIC_STARTER],
}


func random_starter_deck_id() -> int:
	var rand_deck: int = starter_decks[starter_decks.keys().pick_random()]["ID"]
	return rand_deck
