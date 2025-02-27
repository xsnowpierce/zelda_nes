extends Node

var tile_dictionary : Dictionary
var current_tile : Vector2

func _ready() -> void:
	for child in get_children():
		tile_dictionary[child.tile_area_position] = child

func new_tile_entered(tile : Vector2) -> void:
	if(tile_dictionary.has(tile)):
		tile_dictionary[tile].tile_entered(current_tile)
		if(tile_dictionary.has(current_tile)):
			tile_dictionary[current_tile].tile_exited(tile)
		current_tile = tile


func _on_camera_2d_camera_moved(new_area_position: Vector2) -> void:
	new_tile_entered(new_area_position)
