extends Node

class_name ConsoleCommand

func get_command_tag() -> String:
	return "none"

func get_command_description() -> String:
	return "no description." 

func execute_command(args : Array[String]) -> String:
	return "Command not implemented."

func get_command_usage() -> String:
	return "none [amount]"

func _return_improper_usage() -> String:
	return _err("Improper usage. " + get_command_usage() + "\n")

func _err(text : String) -> String:
	return "[color=red]" + text + "[/color]\n"
