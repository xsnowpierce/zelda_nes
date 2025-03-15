extends ConsoleCommand

var item_lookup : Dictionary = {}

func get_command_tag() -> String:
	return "give"

func get_command_description() -> String:
	return "Gives a player the specified item." 

func get_command_usage() -> String:
	return "give <item> [amount : int]"

func execute_command(args : Array[String]) -> String:
	var item_amount : int = 1
	if(args.size() == 2):
		if(args[1].is_valid_int()):
			item_amount = int(args[1])
		else:
			return _return_improper_usage()
	match args[0]:
		"rupee":
			return try_give_item(ENUM.ITEM_TYPE.GREEN_RUPEE, item_amount)
		"key":
			return try_give_item(ENUM.ITEM_TYPE.DOOR_KEY, item_amount)
		_:
			var item_requested : ENUM.ITEM_TYPE = _get_item_type(args[0])
			if(item_requested == ENUM.ITEM_TYPE.NULL):
				return _err("The item \"" + args[0] + "\" does not exist. Please try again.")
			else:
				return try_give_item(item_requested, item_amount)
	return _err("Error has occurred. Please try again.")

func _ready() -> void:
	for key in ENUM.ITEM_TYPE.keys():
		item_lookup[key.to_lower()] = ENUM.ITEM_TYPE[key]

func _get_item_type(item_name : String) -> int:
	return item_lookup.get(item_name.to_lower(), ENUM.ITEM_TYPE.NULL)

func try_give_item(item : ENUM.ITEM_TYPE, amount : int) -> String:
	var player : GameData = get_tree().get_first_node_in_group("GameData")
	player.give_player_item(item, amount)
	return "Item given."
