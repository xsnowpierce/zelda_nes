extends ConsoleCommand

func get_command_tag() -> String:
	return "tp"

func get_command_description() -> String:
	return "Teleport to somewhere."

func get_command_usage() -> String:
	return "\"tp <place:coordinate>\". Example: \"tp 1,-12\", or \"tp level1\""

func execute_command(args : Array[String]) -> String:
	if(args.size() == 0):
		return _return_improper_usage()
	var destination : String = args[0]
	if(!args[0][0].is_valid_int()):
		destination = _try_get_preset_position(args[0])
	var split_destination_coords : PackedStringArray = destination.split(",", false)
	if(split_destination_coords.size() != 2):
		print("wrong arg length")
		return _return_improper_usage()
	if(!split_destination_coords[0].is_valid_int() or !split_destination_coords[1].is_valid_int()):
		print("not valid ints: " + split_destination_coords[0] + " " + split_destination_coords[1])
		return _return_improper_usage()
	get_tree().get_first_node_in_group("GameData").teleport_player(Vector2(int(split_destination_coords[0]), int(split_destination_coords[1])))
	return "Teleported player to " + destination

func _try_get_preset_position(arg : String) -> String:
	match arg:
		"level1":
			return "0,-4"
		_:
			return "not valid"
