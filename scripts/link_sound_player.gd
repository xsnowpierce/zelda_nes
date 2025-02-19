extends AudioStreamPlayer

@export_group("SFX Files")
@export var sword_swing_sound := preload("res://sound/sfx/sword_Swing.wav")
@export var attacked_sound := preload("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Player Hurt.wav")
@export var door_enter_sound := preload("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Walking on Stairs.wav")
@export var key_item_pickup := preload("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Item Received.wav")
@export var shield_block := preload("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Shield Deflecting.wav")

func play_sound(sound : AudioStream) -> void:
	stream = sound
	play(0.0)
	
func play_attacked_sound() -> void:
	play_sound(attacked_sound)

func play_shield_block_sound() -> void:
	play_sound(shield_block)

func play_sword_swing_sound() -> void:
	play_sound(sword_swing_sound)

func play_door_enter_sound() -> void:
	play_sound(door_enter_sound)

func play_key_item_pickup_sound() -> void:
	play_sound(key_item_pickup)
