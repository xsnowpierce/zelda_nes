extends Node2D

var tile_area_position : Vector2

func _ready() -> void:
	tile_area_position = Vector2(global_position.x / 16 / 16, global_position.y / 16 / 11)

func tile_entered(previous_tile : Vector2) -> void:
	pass

func tile_exited(next_tile : Vector2) -> void:
	pass
