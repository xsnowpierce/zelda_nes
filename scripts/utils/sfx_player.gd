extends AudioStreamPlayer

class_name SFXPlayer

@export var secret_discover_sfx : AudioStreamWAV
@export var enemy_death_sfx : AudioStreamWAV
@export var enemy_hurt_sfx : AudioStreamWAV
@export var rupee_pickup_sfx : AudioStreamWAV
@export var heart_pickup_sfx : AudioStreamWAV
@export var heart_container_pickup : AudioStreamWAV
@export var sword_swing_sfx : AudioStreamWAV
@export var bomb_explosion_sfx : AudioStreamWAV
@export var key_item_pickup_sfx : AudioStreamWAV
@export var fire_shot_sfx : AudioStreamWAV
@export var magical_wand_shoot : AudioStreamWAV
@export var whistle_music : AudioStreamWAV
@export var door_open_sfx : AudioStreamWAV
@export var key_appearance_sfx : AudioStreamWAV
@export var boomerang_loop_sfx : AudioStreamWAV
@export var aquamentus_roar_sfx : AudioStreamWAV
@export var sword_beam_sfx : AudioStreamWAV
@export var aquamentus_hurt_sfx : AudioStreamWAV

enum SFX {SECRET_DISCOVER, ENEMY_DEATH, ENEMY_HURT, RUPEE_PICKUP, HEART_PICKUP, 
	HEART_CONTAINER_PICKUP,
	SWORD_SWING, BOMB_EXPLOSION, KEY_ITEM_PICKUP, FIRE_SHOT, MAGICAL_WAND_SHOOT,
	WHISTLE_MUSIC, DOOR_OPEN, KEY_APPEARANCE, BOOMERANG, AQUAMENTUS_ROAR, SWORD_BEAM,
	AQUAMENTUS_HURT }

func play_sound(sfx : SFX) -> void:
	stream = get_audio_file_from_enum(sfx)
	play(0.0)

func get_audio_file_from_enum(sfx : SFX) -> AudioStreamWAV:
	match sfx:
		SFX.SECRET_DISCOVER:
			return secret_discover_sfx
		SFX.ENEMY_DEATH:
			return enemy_death_sfx
		SFX.ENEMY_HURT:
			return enemy_hurt_sfx
		SFX.RUPEE_PICKUP:
			return rupee_pickup_sfx
		SFX.HEART_PICKUP:
			return heart_pickup_sfx
		SFX.HEART_CONTAINER_PICKUP:
			return heart_container_pickup
		SFX.SWORD_SWING:
			return sword_swing_sfx
		SFX.BOMB_EXPLOSION:
			return bomb_explosion_sfx
		SFX.KEY_ITEM_PICKUP:
			return key_item_pickup_sfx
		SFX.FIRE_SHOT:
			return fire_shot_sfx
		SFX.MAGICAL_WAND_SHOOT:
			return magical_wand_shoot
		SFX.WHISTLE_MUSIC:
			return whistle_music
		SFX.DOOR_OPEN:
			return door_open_sfx
		SFX.KEY_APPEARANCE:
			return key_appearance_sfx
		SFX.BOOMERANG:
			return boomerang_loop_sfx
		SFX.AQUAMENTUS_ROAR:
			return aquamentus_roar_sfx
		SFX.SWORD_BEAM:
			return sword_beam_sfx
		SFX.AQUAMENTUS_HURT:
			return aquamentus_hurt_sfx
		_:
			return

func loop_sound(sfx : SFX) -> void:
	stream = get_audio_file_from_enum(sfx)
	play(0.0)
