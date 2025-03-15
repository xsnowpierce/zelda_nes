extends CanvasLayer

var console_open : bool = true
var previous_command : String = ""

func _process(delta: float) -> void:
	if(console_open):
		$VBoxContainer/TextEdit.grab_focus()

func _input(event: InputEvent) -> void:
	if(!console_open):
		return
	if(event is InputEventKey and event.is_released()):
		match event.physical_keycode:
			4194309: ## enter key
				try_send_command($VBoxContainer/TextEdit.text)
				$VBoxContainer/TextEdit.text = ""
			4194320: ## up arrow key
				$VBoxContainer/TextEdit.text = previous_command
			4194322: ## down arrow key
				$VBoxContainer/TextEdit.text = ""

func try_send_command(command : String) -> void:
	var command_and_args : PackedStringArray = command.strip_edges().to_lower().split(" ", false)
	var found_command : bool = false
	for child in $Commands.get_children():
		if(child is ConsoleCommand):
			if(child.get_command_tag() == command_and_args.get(0)):
				var result : String = child.execute_command(command_and_args.slice(1, command_and_args.size()))
				$VBoxContainer/RichTextLabel.append_text(result + "\n")
				found_command = true
				break
			
	if(!found_command):
		$VBoxContainer/RichTextLabel.append_text("[color=red]Command \"" + command_and_args.get(0) + "\" was not found. Please try again.[/color]\n")
	previous_command = command
