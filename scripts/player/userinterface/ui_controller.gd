extends TextureRect

func set_text_amount(amount : int) -> void:
	if(amount <= 9):
		$Label.text = "x" + str(amount)
	elif(amount > 9 and amount <= 99):
		$Label.text = "x" + str(amount)
	elif(amount <= 255):
		$Label.text = str(amount)
	else:
		$Label.text = "a"

# even if we're not wanting any of these, it doesnt matter because they'll
# only be called if they're connected to the main GameData signal to update it.
func _on_game_bombs_changed(new_current_amount: int) -> void:
	set_text_amount(new_current_amount)


func _on_game_keys_changed(new_current_amount: int) -> void:
	set_text_amount(new_current_amount)


func _on_game_rupees_changed(new_current_amount: int) -> void:
	set_text_amount(new_current_amount)
