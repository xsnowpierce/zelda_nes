extends Area2D

enum ITEM_TYPE {GREEN_RUPEE,BLUE_RUPEE,HEART}
@export var item_type : ITEM_TYPE
@export var rupee_gain_sound : AudioStreamWAV
@export var heart_gain_sound : AudioStreamWAV

func _ready() -> void:
	set_item_type(item_type)

func set_item_type(type : ITEM_TYPE) -> void:
	item_type = type
	match type:
		ITEM_TYPE.GREEN_RUPEE:
			$AnimatedSprite2D.play("green_rupee")
		ITEM_TYPE.BLUE_RUPEE:
			$AnimatedSprite2D.play("blue_rupee")
		ITEM_TYPE.HEART:
			$AnimatedSprite2D.play("heart")
		
func _on_area_entered(area: Area2D) -> void:
	var game_data = get_tree().get_first_node_in_group("GameData")
	match item_type:
		ITEM_TYPE.GREEN_RUPEE:
			game_data.change_rupees(1)
			$AudioStreamPlayer.stream = rupee_gain_sound
			$AudioStreamPlayer.play()
		ITEM_TYPE.BLUE_RUPEE:
			game_data.change_rupees(5)
			$AudioStreamPlayer.stream = rupee_gain_sound
			$AudioStreamPlayer.play()
		ITEM_TYPE.HEART:
			game_data.player_gain_heart(1)
			$AudioStreamPlayer.stream = heart_gain_sound
			$AudioStreamPlayer.play()
	$AnimatedSprite2D.visible = false
	while $AudioStreamPlayer.playing:
		await get_tree().process_frame
	queue_free()
