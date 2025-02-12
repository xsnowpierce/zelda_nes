extends AudioStreamPlayer

@export var sword_swing_sound := preload("res://sound/sfx/sword_Swing.wav")
@export var attacked_sound := preload("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Player Hurt.wav")

func _on_link_attack() -> void:
	stream = sword_swing_sound
	play()


func _on_damaged(_damage: int) -> void:
	stream = attacked_sound
	play()
