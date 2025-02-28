extends Node2D

func tile_entered(previous_tile : Vector2) -> void:
	$"Dungeon Tile Doors".set_room_active(true)

func tile_exited(next_tile : Vector2) -> void:
	$"Dungeon Tile Doors".set_room_active(false)
