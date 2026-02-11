extends NormalOpponent


func _ready() -> void:
	abilities = {
		0: {
			"ID": "CREATE_CONSTRUCTION_OBSTRUCTION",
			"WeightFactor": 1,
			#"Func": func(): add_1_to_random_stat(),
			#"Prepare": func(): prepare_add_1_to_random_stat(),
			"Text": "Create an Obstruction Construction",
			"MinTurn": 0,
			"MaxTurn": 0,
			#"Cleanup": func(): cleanup_add_1_to_random_stat(),
		},
		
		1: {
			"ID": "CREATE_SNEK",
			"WeightFactor": 1,
			#"Func": func(): add_1_to_random_stat(),
			#"Prepare": func(): prepare_add_1_to_random_stat(),
			"Text": "Create a SNEK",
			"MinTurn": 1,
			"MaxTurn": 2,
			#"Cleanup": func(): cleanup_add_1_to_random_stat(),
		},
		
		2: {
			"ID": "CREATE_PROTECTOR_OF_THE_FOREST",
			"WeightFactor": 1,
			#"Func": func(): add_1_to_random_stat(),
			#"Prepare": func(): prepare_add_1_to_random_stat(),
			"Text": "Create a Protector of the Forest",
			"MinTurn": 3,
			"MaxTurn": -1,
			#"Cleanup": func(): cleanup_add_1_to_random_stat(),
		},
}
