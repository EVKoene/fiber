extends Node

var cards = load("res://battle/card/CardDatabase.gd").cards
enum deck_ids {
	PASSION_STARTER, IMAGINATION_STARTER, GROWTH_STARTER, LOGIC_STARTER, GORILLA, 
	MOVEMENT_SHENANIGANS, IMAGINATION_MISSILES, SPELL_SLINGERS, SHALLAN, LOGIC_FACTORY, 
	RESOURCE_EXTRAVAGANZA, STRENGTH_IN_NUMBERS, BILL_GATES, GOLEMS, 
	ELEMENTS, BEEFY_BOYS, FRENZY_START, TUTORIAL_DECK, 
	GURU_LAGHIMA, OPPONENT_TESTING, PLAYER_TESTING, SMELLY_JACQUES, MINIBOSS 
	}


var decks := {
	### STARTER DECKS ###
	
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
			cards.ICE_GOLEM: 1,
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
	
	### PASSION ###
	
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
	
	### IMAGINATION ###
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
	
	deck_ids.MOVEMENT_SHENANIGANS: {
		"DeckName": "MovementShenanigans",
		"Cards": {
			cards.WIZARD_SCOUT: 15,
			cards.SWITCHEROO: 10,
			cards.INSPIRING_ARTIST: 10,
			cards.FLOW_ACCELERATOR: 15,
			cards.HYRSMIR_RULER_OF_PHYSICS: 5,
		},
		"StartingCards": {
			cards.WIZARD_SCOUT: 2,
			cards.FLOW_ACCELERATOR: 1,
		},
		"ID": deck_ids.MOVEMENT_SHENANIGANS,
	},
	
	deck_ids.SPELL_SLINGERS: {
		"DeckName": "Spell Slingers",
		"Cards": {
			cards.IMAGINARY_FRIEND: 15,
			cards.SWITCHEROO: 10,
			cards.ARCANE_ARROW: 10,
			cards.DREAMFINDER: 10,
			cards.AUDACIOUS_RESEARCHER: 15,
			cards.STREAM_OF_THOUGHT: 15,
		},
		"StartingCards": {
			cards.IMAGINARY_FRIEND: 2,
			cards.SWITCHEROO: 1,
		},
		"ID": deck_ids.SPELL_SLINGERS,
	},
	
	deck_ids.SHALLAN: {
		"DeckName": "Shallan",
		"Cards": {
			cards.IMAGINARY_FRIEND: 10,
			cards.SWITCHEROO: 10,
			cards.MIST_CONJURER: 10,
			cards.ARCANE_ARROW: 10, 
			cards.HOMUNCULUS: 5,
			cards.FLOW_ACCELERATOR: 5,
			cards.STREAM_OF_THOUGHT: 10,
			cards.HYRSMIR_RULER_OF_PHYSICS: 3, 
		},
		"StartingCards": {
			cards.IMAGINARY_FRIEND: 2,
			cards.ARCANE_ARROW: 1,
		},
		
		"ID": deck_ids.SHALLAN,
	},
	
	### GROWTH ###
	
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
			cards.GNOME_PROTECTOR: 2,
			cards.WIND_GOLEM: 1,
		},
		
		"ID": deck_ids.ELEMENTS,
	},
	
	deck_ids.GURU_LAGHIMA: {
		"DeckName": "Elements",
		"Cards": {
			cards.GNOME_PROTECTOR: 10,
			cards.MORNING_LIGHT: 10,
			cards.STUDENT_OF_KHONG: 10,
			cards.HAIL_STORM: 5, 
			cards.EARTH_GOLEM: 10,
			cards.VOLCANIC_ERUPTION: 5,
			cards.BRINGER_OF_ENLIGHTENMENT: 10,
			cards.MARCELLA_WHO_NURTURES_GROWTH: 5, 
		},
		"StartingCards": {
			cards.GNOME_PROTECTOR: 2,
			cards.WIND_GOLEM: 2,
		},
		
		"ID": deck_ids.ELEMENTS,
	},
	
	### LOGIC 
	
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
	
	deck_ids.RESOURCE_EXTRAVAGANZA: {
		"DeckName": "Resource Extravaganza",
		"Cards": {
			cards.OBSTRUCTION_CONSTRUCTION: 15, 
			cards.SHOCK_CHARGE: 5,
			cards.FACTORY_WORKER: 15, 
			cards.RESOURCE_EXTRACTOR: 10,
			cards.PLUG_BUDDY: 10,
			cards.SUPPLY_DELIVERY: 10,
		},
		"StartingCards": {
			cards.OBSTRUCTION_CONSTRUCTION: 2,
			cards.FACTORY_WORKER: 1,
		},
		"ID": deck_ids.RESOURCE_EXTRAVAGANZA,
	},
	
	deck_ids.STRENGTH_IN_NUMBERS: {
		"DeckName": "Strength in Numbers",
		"Cards": {
			cards.ASSEMBLY_BOT: 15, 
			cards.FUEL_DISTRIBUTER: 15, 
			cards.NETWORK_FEEDER: 10,
			cards.EXTERMINATE: 10,
			cards.FURNACE_BOT: 10,
		},
		"StartingCards": {
			cards.ASSEMBLY_BOT: 2,
			cards.NETWORK_FEEDER: 1,
		},
		"ID": deck_ids.STRENGTH_IN_NUMBERS,
	},
	
	deck_ids.BILL_GATES: {
		"DeckName": "Strength in Numbers",
		"Cards": {
			cards.ASSEMBLY_BOT: 15, 
			cards.SHOCK_CHARGE: 15, 
			cards.FUEL_DISTRIBUTER: 10,
			cards.RESOURCE_EXTRACTOR: 10,
			cards.EXTERMINATE: 10,
			cards.FURNACE_BOT: 10,
			cards.PLUG_BUDDY: 5,
			cards.COMPUTING_BOT: 10,
			cards.ZALOGI_MIND_OF_MACHINES: 3,
			cards.SUPPLY_DELIVERY: 5,
			
		},
		"StartingCards": {
			cards.ASSEMBLY_BOT: 2,
			cards.NETWORK_FEEDER: 1,
		},
		"ID": deck_ids.BILL_GATES,
	},
	
	### MISC ###
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
			cards.FUEL_DISTRIBUTER: 10,
			cards.RESOURCE_EXTRACTOR: 10,
			cards.SUPPLY_DELIVERY: 10,
		},
		"StartingCards": {
			cards.FUEL_DISTRIBUTER: 1,
			cards.RESOURCE_EXTRACTOR: 1,
			cards.SUPPLY_DELIVERY: 1,
		},
		"ID": deck_ids.OPPONENT_TESTING,
	},

	deck_ids.PLAYER_TESTING: {
		"DeckName": "Player testing",
		"Cards": {
			cards.FUEL_DISTRIBUTER: 10,
			cards.RESOURCE_EXTRACTOR: 10,
			cards.SUPPLY_DELIVERY: 10,
		},
		"StartingCards": {
			cards.FUEL_DISTRIBUTER: 1,
			cards.RESOURCE_EXTRACTOR: 1,
			cards.SUPPLY_DELIVERY: 1,
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
