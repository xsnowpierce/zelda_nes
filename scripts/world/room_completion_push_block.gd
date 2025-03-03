extends DungeonTileListener

func block_pushed() -> void:
	var sfxplayer : SFXPlayer = get_tree().get_first_node_in_group("SFXPlayer")
	sfxplayer.play_sound(SFXPlayer.SFX.SECRET_DISCOVER)
