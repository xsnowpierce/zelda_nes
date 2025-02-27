extends Node

func _on_burnable_tile_was_burned() -> void:
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.SECRET_DISCOVER)
