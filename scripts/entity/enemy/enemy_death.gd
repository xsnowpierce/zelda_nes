extends Node2D

var player_authority : PlayerData

func set_player_authority(player : PlayerData) -> void:
	player_authority = player
	print("set", global_position)

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.visible = false
	player_authority.enemy_drop_item(global_position)
	queue_free()
