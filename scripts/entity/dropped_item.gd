extends Area2D

@export var item_type : ENUM.ITEM_TYPE
@export var rupee_value_override : int = -1
@export var rupee_gain_sound : AudioStreamWAV
@export var heart_gain_sound : AudioStreamWAV
signal item_picked_up
var sfxplayer : SFXPlayer
var times_picked_up : int

func _ready() -> void:
	set_item_type(item_type)
	sfxplayer = get_tree().get_first_node_in_group("SFXPlayer")

func set_item_type(type : ENUM.ITEM_TYPE) -> void:
	item_type = type
	match type:
		ENUM.ITEM_TYPE.GREEN_RUPEE:
			$AnimatedSprite2D.play("green_rupee")
		ENUM.ITEM_TYPE.BLUE_RUPEE:
			$AnimatedSprite2D.play("blue_rupee")
		ENUM.ITEM_TYPE.HEART:
			$AnimatedSprite2D.play("heart")
		ENUM.ITEM_TYPE.KEY:
			$AnimatedSprite2D.play("key")
		
func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player_Bomb")):
		return
	if(times_picked_up > 0):
		return
	times_picked_up += 1
	var game_data = get_tree().get_first_node_in_group("GameData")
	match item_type:
		ENUM.ITEM_TYPE.GREEN_RUPEE:
			if(rupee_value_override != -1):
				game_data.change_rupees(rupee_value_override)
			else:
				game_data.change_rupees(1)
			sfxplayer.play_sound(SFXPlayer.SFX.RUPEE_PICKUP)
		ENUM.ITEM_TYPE.BLUE_RUPEE:
			if(rupee_value_override != -1):
				game_data.change_rupees(rupee_value_override)
			else:
				game_data.change_rupees(5)
			sfxplayer.play_sound(SFXPlayer.SFX.RUPEE_PICKUP)
		ENUM.ITEM_TYPE.HEART:
			game_data.player_gain_heart(2)
			sfxplayer.play_sound(SFXPlayer.SFX.HEART_PICKUP)
		ENUM.ITEM_TYPE.KEY:
			game_data.change_keys(1)
			sfxplayer.play_sound(SFXPlayer.SFX.HEART_PICKUP)
	$AnimatedSprite2D.visible = false
	item_picked_up.emit()
	queue_free()
