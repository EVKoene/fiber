extends Panel

class_name ResourceBar


func set_resources_labels(
	gold: int,
	passion: int,
	imagionation: int,
	growth: int,
	logic: int
) -> void:
	#TODO: We don't want this to get called before the scene is ready. There should be a more 
	# elegant solution though.
	if get_child_count() == 0:
		return
	
	for f in [
		[$CostLabels/Gold, gold],
		[$CostLabels/Passion, passion], 
		[$CostLabels/Imagination, imagionation],
		[$CostLabels/Growth, growth],
		[$CostLabels/Logic, logic],
	]:
		f[0].text = str(f[1])
		if f[1] > 0:
			f[0].show()
		else:
			f[0].hide()
