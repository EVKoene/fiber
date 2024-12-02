extends Node

var cards = load("res://card/CardDatabase.gd").cards
enum deck_ids {
	PASSION_STARTER, IMAGINATION_STARTER, GROWTH_STARTER, LOGIC_STARTER, GORILLA, 
	IMAGINATION_MISSILES, LOGIC_FACTORY, BEEFY_BOYS, FRENZY_START, TUTORIAL_DECK, OPPONENT_TESTING,
	PLAYER_TESTING,
	}


var decks := {
	deck_ids.PASSION_STARTER: {
		"DeckName": "PassionStarter",
		"Cards": {
			cards.GORILLA: 4, 
			cards.ATTACK_COMMAND: 2, 
			cards.GOOSE: 2, 
			cards.WARTHOG_BERSERKER: 4, 
			cards.GORILLA_BATTLECALLER: 2, 
			cards.SNEK: 2,
			cards.FOLLOW_PHEROMONES: 3, 
			cards.STAMPEDE: 2, 
			cards.FELOS_EXPEDITIONIST: 3, 
			cards.SKON_INSECT_FATHER: 1	
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
			cards.WIZARD_SCOUT: 2,
			cards.SWITCHEROO: 2, 
			cards.ARCANE_ARROW: 4, 
			cards.MIST_CONJURER: 3, 
			cards.FLOW_ACCELERATOR: 4, 
			cards.EPHEMERAL_ASSASSIN: 2, 
			cards.FIREBALL_SHOOTER: 2, 
			cards.HOMUNCULUS: 4, 
			cards.JELLYFISH_EXTRAORDINAIRE: 2, 
			cards.AUDACIOUS_RESEARCHER: 2, 
			cards.HYRSMIR_RULER_OF_PHYSICS: 1, 
			cards.PSYCHIC_TAKEOVER: 2,
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
			cards.GNOME_PROTECTOR: 2,  
			cards.BOTANO_GARDENER: 2, 
			cards.MORNING_LIGHT: 3, 
			cards.ICE_GOLEM: 2, 
			cards.FIRE_GOLEM: 2, 
			cards.HAIL_STORM: 2, 
			cards.EARTH_GOLEM: 4, 
			cards.PROTECTOR_OF_THE_FOREST: 2, 
			cards.PRANCING_VERDEN: 2, 
			cards.HEART_OF_THE_FOREST: 2, 
			cards.MARCELLA_WHO_NURTURES_GROWTH: 2, 
			cards.VOLCANIC_ERUPTION: 2
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
			cards.ASSEMBLY_BOT: 1, 
			cards.OBSTRUCTION_CONSTRUCTION: 2, 
			cards.SHOCK_CHARGE: 3, 
			cards.FACTORY_WORKER: 2, 
			cards.NETWORK_FEEDER: 3, 
			cards.FURNACE_BOT: 2, 
			cards.EXTERMINATE: 2, 
			cards.PLUG_BUDDY: 3, 
			cards.COMPUTING_BOT: 1, 
			cards.ZOLOI_CHARGER: 2, 
			cards.COPY_MACHINE: 1, 
			cards.ZALOGI_MIND_OF_MACHINES: 2, 
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
		"Cards": {
			cards.GORILLA: 10,
		},
		"StartingCards": {
			cards.GORILLA_KING: 3
		},
		"DeckName": "Player testing",
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
