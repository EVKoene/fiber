extends CenterContainer


class_name SelectFiber

@onready var save_path := "user://savedata/"
@onready var collections_path := str(save_path, "collections.ini")

func _ready() -> void:
	GameManager.current_scene = self
	var config := ConfigFile.new()
	if !FileAccess.file_exists(collections_path):
		var create_dir_error := DirAccess.make_dir_recursive_absolute(save_path)
		if create_dir_error:
			print("Error creating directory: ", error_string(create_dir_error))
	else:
		config.load(collections_path)
	
	config.set_value("deck_data", "decks", {})
	config.set_value("card_collection", "cards", {})
	var save_error := config.save(collections_path)
	if save_error:
		print("Error creating collections file: ", error_string(save_error))


func start_journey_with_fiber(fiber: int) -> void:
	GameManager.setup_starter_deck(fiber)
	TransitionScene.transition_to_overworld_scene(AreaDatabase.area_ids.STARTING)


func _input(_event):
	if (
		Input.is_action_just_pressed("ui_accept") 
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	):
		$VBoxContainer/StartJourneyText.text = str("
			What describes you best? (It's very important you think long and carefully about
			this because the implications are huge)
		")
		$VBoxContainer/FiberButtons.show()
	

func _on_passion_pressed():
	start_journey_with_fiber(Collections.fibers.PASSION)


func _on_imagination_pressed():
	start_journey_with_fiber(Collections.fibers.IMAGINATION)


func _on_growth_pressed():
	start_journey_with_fiber(Collections.fibers.GROWTH)


func _on_logic_pressed():
	start_journey_with_fiber(Collections.fibers.LOGIC)
