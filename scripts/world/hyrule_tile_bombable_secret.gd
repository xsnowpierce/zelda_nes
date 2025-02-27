extends Node

func _on_bombable_tile_was_bombed() -> void:
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.SECRET_DISCOVER)
