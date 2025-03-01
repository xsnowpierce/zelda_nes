extends Node

var tile_dictionary : Dictionary
var current_tile : Vector2

func _ready() -> void:
	await get_tree().process_frame
	for child in get_children():
		tile_dictionary[child.tile_area_position] = child

func new_tile_entered(tile : Vector2) -> void:
	if(tile_dictionary.has(tile)):
		if(tile_dictionary[tile].tile_area_position == tile):
			await stall_room_loading(tile_dictionary[tile])
			tile_dictionary[tile].tile_entered(tile)
			current_tile = tile
	else:
		current_tile = Vector2.INF

func stall_room_loading(tile_to_load : TileArea) -> void:
	pass

func _on_camera_2d_camera_moved(new_area_position: Vector2) -> void:
	new_tile_entered(new_area_position)

func _on_camera_2d_camera_start_moving(new_area_position : Vector2) -> void:
	if(tile_dictionary.has(current_tile)):
			tile_dictionary[current_tile].tile_exited(new_area_position)
