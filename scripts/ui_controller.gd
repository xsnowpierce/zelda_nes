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
