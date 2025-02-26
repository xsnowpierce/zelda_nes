extends "res://scripts/hyrule_tile_area.gd"

func _on_pushable_block_was_pushed() -> void:
	if(is_instance_valid($"Fake Block Cover")):
		$"Fake Block Cover".queue_free()
	var sfxplayer : SFXPlayer = get_tree().get_first_node_in_group("SFXPlayer")
	sfxplayer.play_sound(SFXPlayer.SFX.SECRET_DISCOVER)
