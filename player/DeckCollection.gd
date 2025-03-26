extends Node

var cards = load("res://card/CardDatabase.gd").cards
enum deck_ids {
	### PASSION ###
	PASSION_STARTER,
	GORILLA,
	FRENZY_START,
	SMELLY_JACQUES,
	GARY,
	GOTTA_GO_FAST,
	BIG_ATTACK,
	STAY_AWAY,
	### IMAGINATION ###
	IMAGINATION_STARTER,
	FLOW_AND_INSPIRE,
	MOVEMENT_SHENANIGANS,
	SPELLS_WHAT_ELSE,
	IMAGINATION_MISSILES,
	SPELL_SLINGERS,
	TAKE_OVER,
	SHALLAN,
	### GROWTH ###
	GROWTH_STARTER,
	GOLEMS,
	ELEMENTS,
	BEEFY_BOYS,
	PATIENCE,
	FAST_GNOMES,
	FIRE,
	GURU_LAGHIMA,
	### LOGIC ###
	LOGIC_STARTER,
	LOGIC_FACTORY,
	RESOURCE_EXTRAVAGANZA,
	STRENGTH_IN_NUMBERS,
	BILL_GATES,
	### MISC ###
	TUTORIAL_DECK,
	OPPONENT_TESTING,
	PLAYER_TESTING,
}

var decks := {
	### STARTER DECKS ###
	deck_ids.PASSION_STARTER:
	{
		"DeckName": "PassionStarter",
		"Cards":
		{
			cards.GORILLA: 8,
			cards.ATTACK_COMMAND: 4,
			cards.GOOSE: 8,
			cards.GORILLA_BATTLECALLER: 4,
			cards.FOLLOW_PHEROMONES: 4,
			cards.FELOS_EXPEDITIONIST: 2,
		},
		"StartingCards":
		{
			cards.GORILLA: 2,
			cards.GOOSE: 1,
		},
		"ID": deck_ids.PASSION_STARTER,
	},
	deck_ids.IMAGINATION_STARTER:
	{
		"DeckName": "ImaginationStarter",
		"Cards":
		{
			cards.WIZARD_SCOUT: 8,
			cards.ARCANE_ARROW: 4,
			cards.MIST_CONJURER: 8,
			cards.EPHEMERAL_ASSASSIN: 4,
			cards.HOMUNCULUS: 4,
			cards.JELLYFISH_EXTRAORDINAIRE: 2,
		},
		"StartingCards":
		{
			cards.WIZARD_SCOUT: 2,
			cards.ARCANE_ARROW: 1,
		},
		"ID": deck_ids.IMAGINATION_STARTER,
	},
	deck_ids.GROWTH_STARTER:
	{
		"DeckName": "GrowthStarter",
		"Cards":
		{
			cards.GNOME_PROTECTOR: 8,
			cards.MORNING_LIGHT: 4,
			cards.ICE_GOLEM: 8,
			cards.EARTH_GOLEM: 4,
			cards.PROTECTOR_OF_THE_FOREST: 4,
			cards.HEART_OF_THE_FOREST: 2,
		},
		"StartingCards":
		{
			cards.GNOME_PROTECTOR: 2,
			cards.ICE_GOLEM: 1,
		},
		"ID": deck_ids.GROWTH_STARTER,
	},
	deck_ids.LOGIC_STARTER:
	{
		"DeckName": "LogicStarter",
		"Cards":
		{
			cards.ASSEMBLY_BOT: 8,
			cards.FACTORY_WORKER: 4,
			cards.NETWORK_FEEDER: 8,
			cards.FURNACE_BOT: 4,
			cards.EXTERMINATE: 4,
			cards.COMPUTING_BOT: 2,
		},
		"StartingCards":
		{
			cards.ASSEMBLY_BOT: 2,
			cards.FACTORY_WORKER: 1,
		},
		"ID": deck_ids.LOGIC_STARTER,
	},
	### PASSION_LEVEL_1 ###
	deck_ids.GORILLA:
	{
		"DeckName": "Gorilla",
		"Cards":
		{
			cards.GORILLA: 20,
			cards.GORILLA_BATTLECALLER: 10,
			cards.GORILLA_KING: 20,
		},
		"StartingCards":
		{
			cards.GORILLA: 3,
		},
		"ID": deck_ids.GORILLA,
	},
	deck_ids.BIG_ATTACK:
	{
		"DeckName": "Big Attack",
		"Cards":
		{
			cards.GORILLA: 10,
			cards.ATTACK_COMMAND: 20,
			cards.CRAZED_GAMBLER: 15,
			cards.YOUNG_DRIVEN_MINOTAUR: 15,
			cards.GORILLA_BATTLECALLER: 5,
			cards.FELOS_EXPEDITIONIST: 10,
		},
		"StartingCards":
		{
			cards.GORILLA: 2,
			cards.YOUNG_DRIVEN_MINOTAUR: 1,
		},
		"ID": deck_ids.BIG_ATTACK,
	},
	deck_ids.STAY_AWAY:
	{
		"DeckName": "Stay Away",
		"Cards":
		{
			cards.FANATIC_FOLLOWER: 10,
			cards.ATTACK_COMMAND: 20,
			cards.GOOSE: 5,
			cards.SNEK: 15,
			cards.FOLLOW_PHEROMONES: 15,
			cards.STAMPEDE: 5,
			cards.SKON_INSECT_FATHER: 5,
		},
		"StartingCards":
		{
			cards.FANATIC_FOLLOWER: 2,
			cards.SNEK: 1,
		},
		"ID": deck_ids.STAY_AWAY,
	},
	### START_OF_PASSION ###
	deck_ids.GOTTA_GO_FAST:
	{
		"DeckName": "Gotta Go Fast",
		"Cards":
		{
			cards.FANATIC_FOLLOWER: 10,
			cards.VIGOR: 10,
			cards.WARTHOG_BERSERKER: 15,
			cards.GORILLA_BATTLECALLER: 15,
			cards.CHEETAH: 15,
		},
		"StartingCards":
		{
			cards.FANATIC_FOLLOWER: 2,
			cards.GOOSE: 1,
		},
		"ID": deck_ids.GOTTA_GO_FAST,
	},
	deck_ids.FRENZY_START:
	{
		"DeckName": "Frenzy Start",
		"Cards":
		{
			cards.FANATIC_FOLLOWER: 15,
			cards.WARTHOG_BERSERKER: 15,
			cards.SKON_INSECT_FATHER: 10,
		},
		"StartingCards":
		{
			cards.FANATIC_FOLLOWER: 2,
			cards.WARTHOG_BERSERKER: 1,
		},
		"ID": deck_ids.FRENZY_START,
	},
	deck_ids.SMELLY_JACQUES:
	{
		"DeckName": "Smelly Jacques",
		"Cards":
		{
			cards.SNEK: 15,
			cards.FOLLOW_PHEROMONES: 10,
			cards.FELOS_EXPEDITIONIST: 10,
		},
		"StartingCards":
		{
			cards.GORILLA: 2,
			cards.SNEK: 1,
		},
		"ID": deck_ids.SMELLY_JACQUES,
	},
	deck_ids.GARY:
	{
		"DeckName": "Gary",
		"Cards":
		{
			cards.GORILLA: 5,
			cards.ATTACK_COMMAND: 5,
			cards.CRAZED_GAMBLER: 15,
			cards.SNEK: 10,
			cards.FOLLOW_PHEROMONES: 10,
			cards.YOUNG_DRIVEN_MINOTAUR: 15,
			cards.FELOS_EXPEDITIONIST: 10,
			cards.GORILLA_KING: 5,
			cards.SKON_INSECT_FATHER: 5,
		},
		"StartingCards":
		{
			cards.GORILLA: 2,
			cards.CRAZED_GAMBLER: 1,
		},
		"ID": deck_ids.GARY,
	},
	### IMAGINATION ###
	deck_ids.IMAGINATION_MISSILES:
	{
		"DeckName": "ImaginationMissiles",
		"Cards":
		{
			cards.WIZARD_SCOUT: 15,
			cards.ARCANE_ARROW: 10,
			cards.FIREBALL_SHOOTER: 15,
			cards.JELLYFISH_EXTRAORDINAIRE: 5,
		},
		"StartingCards":
		{
			cards.WIZARD_SCOUT: 2,
			cards.ARCANE_ARROW: 1,
		},
		"ID": deck_ids.IMAGINATION_MISSILES,
	},
	deck_ids.MOVEMENT_SHENANIGANS:
	{
		"DeckName": "MovementShenanigans",
		"Cards":
		{
			cards.WIZARD_SCOUT: 15,
			cards.SWITCHEROO: 10,
			cards.INSPIRING_ARTIST: 10,
			cards.FLOW_ACCELERATOR: 15,
			cards.HYRSMIR_RULER_OF_PHYSICS: 5,
		},
		"StartingCards":
		{
			cards.WIZARD_SCOUT: 2,
			cards.FLOW_ACCELERATOR: 1,
		},
		"ID": deck_ids.MOVEMENT_SHENANIGANS,
	},
	
	deck_ids.FLOW_AND_INSPIRE:
	{
		"DeckName": "Flow and Inspire",
		"Cards":
		{
			cards.WIZARD_SCOUT: 8,
			cards.SWITCHEROO: 4,
			cards.INSPIRING_ARTIST: 10,
			cards.FLOW_ACCELERATOR: 10,
			cards.OVERSTIMULATION_FIEND: 6,
			cards.EPHEMERAL_ASSASSIN: 6,
		},
		"StartingCards":
		{
			cards.WIZARD_SCOUT: 2,
			cards.INSPIRING_ARTIST: 1,
		},
		"ID": deck_ids.FLOW_AND_INSPIRE,
	},
	
	deck_ids.SPELL_SLINGERS:
	{
		"DeckName": "Spell Slingers",
		"Cards":
		{
			cards.IMAGINARY_FRIEND: 15,
			cards.SWITCHEROO: 10,
			cards.ARCANE_ARROW: 10,
			cards.DREAMFINDER: 10,
			cards.AUDACIOUS_RESEARCHER: 15,
			cards.STREAM_OF_THOUGHT: 15,
		},
		"StartingCards":
		{
			cards.IMAGINARY_FRIEND: 2,
			cards.SWITCHEROO: 1,
		},
		"ID": deck_ids.SPELL_SLINGERS,
	},
	
	deck_ids.TAKE_OVER:
	{
		"DeckName": "Take Over",
		"Cards":
		{
			cards.IMAGINARY_FRIEND: 15,
			cards.FIREBALL_SHOOTER: 10,
			cards.ARCANE_ARROW: 15,
			cards.DREAMFINDER: 10,
			cards.OVERSTIMULATION_FIEND: 15,
			cards.JELLYFISH_EXTRAORDINAIRE: 10,
			cards.PSYCHIC_TAKEOVER: 15,
		},
		"StartingCards":
		{
			cards.IMAGINARY_FRIEND: 2,
			cards.DREAMFINDER: 1,
		},
		"ID": deck_ids.TAKE_OVER,
	},
	
	deck_ids.SPELLS_WHAT_ELSE:
	{
		"DeckName": "Spells what else",
		"Cards":
		{
			cards.IMAGINARY_FRIEND: 15,
			cards.ARCANE_ARROW: 10,
			cards.DREAMFINDER: 10,
			cards.HOMUNCULUS: 10,
			cards.STREAM_OF_THOUGHT: 15,
			cards.PSYCHIC_TAKEOVER: 5,
		},
		"StartingCards":
		{
			cards.IMAGINARY_FRIEND: 2,
			cards.DREAMFINDER: 1,
		},
		"ID": deck_ids.SPELLS_WHAT_ELSE,
	},
	deck_ids.SHALLAN:
	{
		"DeckName": "Shallan",
		"Cards":
		{
			cards.IMAGINARY_FRIEND: 10,
			cards.SWITCHEROO: 10,
			cards.MIST_CONJURER: 10,
			cards.ARCANE_ARROW: 10,
			cards.HOMUNCULUS: 5,
			cards.FLOW_ACCELERATOR: 5,
			cards.STREAM_OF_THOUGHT: 10,
			cards.HYRSMIR_RULER_OF_PHYSICS: 3,
		},
		"StartingCards":
		{
			cards.IMAGINARY_FRIEND: 2,
			cards.ARCANE_ARROW: 1,
		},
		"ID": deck_ids.SHALLAN,
	},
	### GROWTH ###
	deck_ids.BEEFY_BOYS:
	{
		"DeckName": "Beefy Boys",
		"Cards":
		{
			cards.GNOME_PROTECTOR: 10,
			cards.MORNING_LIGHT: 15,
			cards.EARTH_GOLEM: 15,
			cards.HEART_OF_THE_FOREST: 5,
		},
		"StartingCards":
		{
			cards.GNOME_PROTECTOR: 2,
			cards.MORNING_LIGHT: 1,
		},
		"ID": deck_ids.BEEFY_BOYS,
	},
	deck_ids.GOLEMS:
	{
		"DeckName": "Golems",
		"Cards":
		{
			cards.ICE_GOLEM: 20,
			cards.FIRE_GOLEM: 15,
			cards.EARTH_GOLEM: 15,
		},
		"StartingCards":
		{
			cards.GNOME_PROTECTOR: 3,
		},
		"ID": deck_ids.GOLEMS,
	},
	deck_ids.ELEMENTS:
	{
		"DeckName": "Elements",
		"Cards":
		{
			cards.BOTANO_GARDENER: 5,
			cards.WIND_GOLEM: 10,
			cards.HAIL_STORM: 15,
			cards.EARTH_GOLEM: 10,
			cards.VOLCANIC_ERUPTION: 10,
		},
		"StartingCards":
		{
			cards.GNOME_PROTECTOR: 2,
			cards.WIND_GOLEM: 1,
		},
		"ID": deck_ids.ELEMENTS,
	},
	### START_OF_GROWTH ###
	deck_ids.PATIENCE:
	{
		"DeckName": "Patience",
		"Cards":
		{
			cards.PATIENT_DUDE: 10,
			cards.BOTANO_GARDENER: 15,
			cards.STUDENT_OF_KHONG: 15,
			cards.PROTECTOR_OF_THE_FOREST: 10,
			cards.BRINGER_OF_ENLIGHTENMENT: 15,
		},
		"StartingCards":
		{
			cards.PATIENT_DUDE: 2,
			cards.BOTANO_GARDENER: 1,
		},
		"ID": deck_ids.PATIENCE,
	},
	deck_ids.FAST_GNOMES:
	{
		"DeckName": "Fast Gnomes",
		"Cards":
		{
			cards.GNOME_PROTECTOR: 10,
			cards.MORNING_LIGHT: 15,
			cards.WIND_GOLEM: 15,
			cards.HEART_OF_THE_FOREST: 10,
			cards.PRANCING_VERDEN: 15,
		},
		"StartingCards":
		{
			cards.PATIENT_DUDE: 2,
			cards.BOTANO_GARDENER: 1,
		},
		"ID": deck_ids.FAST_GNOMES,
	},
	deck_ids.FIRE:
	{
		"DeckName": "FIRE",
		"Cards":
		{
			cards.FIRE_GOLEM: 20,
			cards.MORNING_LIGHT: 15,
			cards.WIND_GOLEM: 15,
			cards.EARTH_GOLEM: 10,
			cards.VOLCANIC_ERUPTION: 20,
		},
		"StartingCards":
		{
			cards.PATIENT_DUDE: 2,
			cards.FIRE_GOLEM: 1,
		},
		"ID": deck_ids.FAST_GNOMES,
	},
	deck_ids.GURU_LAGHIMA:
	{
		"DeckName": "Elements",
		"Cards":
		{
			cards.GNOME_PROTECTOR: 10,
			cards.MORNING_LIGHT: 10,
			cards.STUDENT_OF_KHONG: 10,
			cards.HAIL_STORM: 5,
			cards.EARTH_GOLEM: 10,
			cards.VOLCANIC_ERUPTION: 5,
			cards.BRINGER_OF_ENLIGHTENMENT: 10,
			cards.MARCELLA_WHO_NURTURES_GROWTH: 5,
		},
		"StartingCards":
		{
			cards.GNOME_PROTECTOR: 2,
			cards.WIND_GOLEM: 2,
		},
		"ID": deck_ids.ELEMENTS,
	},
	### LOGIC
	deck_ids.LOGIC_FACTORY:
	{
		"DeckName": "Logic Factory",
		"Cards":
		{
			cards.ASSEMBLY_BOT: 15,
			cards.NETWORK_FEEDER: 15,
			cards.FURNACE_BOT: 5,
			cards.COMPUTING_BOT: 5
		},
		"StartingCards":
		{
			cards.ASSEMBLY_BOT: 3,
		},
		"ID": deck_ids.LOGIC_FACTORY,
	},
	deck_ids.RESOURCE_EXTRAVAGANZA:
	{
		"DeckName": "Resource Extravaganza",
		"Cards":
		{
			cards.OBSTRUCTION_CONSTRUCTION: 15,
			cards.SHOCK_CHARGE: 5,
			cards.FACTORY_WORKER: 15,
			cards.RESOURCE_EXTRACTOR: 10,
			cards.PLUG_BUDDY: 10,
			cards.SUPPLY_DELIVERY: 10,
		},
		"StartingCards":
		{
			cards.OBSTRUCTION_CONSTRUCTION: 2,
			cards.FACTORY_WORKER: 1,
		},
		"ID": deck_ids.RESOURCE_EXTRAVAGANZA,
	},
	deck_ids.STRENGTH_IN_NUMBERS:
	{
		"DeckName": "Strength in Numbers",
		"Cards":
		{
			cards.ASSEMBLY_BOT: 15,
			cards.FUEL_DISTRIBUTER: 15,
			cards.NETWORK_FEEDER: 10,
			cards.EXTERMINATE: 10,
			cards.FURNACE_BOT: 10,
		},
		"StartingCards":
		{
			cards.ASSEMBLY_BOT: 2,
			cards.NETWORK_FEEDER: 1,
		},
		"ID": deck_ids.STRENGTH_IN_NUMBERS,
	},
	deck_ids.BILL_GATES:
	{
		"DeckName": "Strength in Numbers",
		"Cards":
		{
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
		"StartingCards":
		{
			cards.ASSEMBLY_BOT: 2,
			cards.NETWORK_FEEDER: 1,
		},
		"ID": deck_ids.BILL_GATES,
	},
	### MISC ###
	deck_ids.TUTORIAL_DECK:
	{
		"DeckName": "Tutorial Deck",
		"Cards":
		{
			cards.GORILLA: 30,
		},
		"StartingCards":
		{
			cards.GORILLA: 3,
		},
		"ID": deck_ids.TUTORIAL_DECK,
	},
	deck_ids.OPPONENT_TESTING:
	{
		"DeckName": "Opponent testing",
		"Cards":
		{
			cards.GORILLA: 30,
		},
		"StartingCards":
		{
			cards.GORILLA: 3,
		},
		"ID": deck_ids.OPPONENT_TESTING,
	},
	deck_ids.PLAYER_TESTING:
	{
		"DeckName": "Player testing",
		"Cards":
		{
			cards.IMAGINARY_FRIEND: 20,
			cards.ARCANE_ARROW: 10,
		},
		"StartingCards":
		{
			cards.WIZARD_SCOUT: 1,
			cards.ATTACK_COMMAND: 1,
			cards.HAIL_STORM: 1,
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


func pick_random_starter_deck() -> Dictionary:
	return decks[random_starter_deck_id]

func random_starter_deck_id() -> int:
	var rand_deck: int = starter_decks[starter_decks.keys().pick_random()]["ID"]
	return rand_deck
