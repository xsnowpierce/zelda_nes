extends Node2D

class_name TileArea

var tile_area_position : Vector2
var tile_is_loaded : bool = false

func _ready() -> void:
	tile_area_position = Vector2(global_position.x / 16 / 16, global_position.y / 16 / 11)

func tile_entered(previous_tile : Vector2) -> void:
	tile_is_loaded = true

func tile_exited(next_tile : Vector2) -> void:
	tile_is_loaded = false
