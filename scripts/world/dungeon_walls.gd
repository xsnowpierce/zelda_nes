extends Node2D

var disable_force_walk_timer : float = 0.1
var is_tile_active : bool

func tile_entered(previous_tile : Vector2) -> void:
	is_tile_active = true
	$"Dungeon Tile Doors".set_room_active(true)

func tile_exited(next_tile : Vector2) -> void:
	is_tile_active = false
	$"Dungeon Tile Doors".set_room_active(false)

func set_force_walk_values(value : bool) -> void:
	$"Link Force Walk/CollisionShape2D".set_disabled(!value)
	$"Link Force Walk2/CollisionShape2D".set_disabled(!value)
	$"Link Force Walk3/CollisionShape2D".set_disabled(!value)
	$"Link Force Walk4/CollisionShape2D".set_disabled(!value)
