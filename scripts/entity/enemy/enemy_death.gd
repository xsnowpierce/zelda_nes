extends Node2D

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.visible = false
	get_tree().get_first_node_in_group("GameData").enemy_drop_item(global_position)
	queue_free()
