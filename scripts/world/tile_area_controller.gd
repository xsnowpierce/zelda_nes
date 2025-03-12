extends Node

var tile_dictionary : Dictionary
var current_tile : Vector2
var first_tile_loaded : bool

func _ready() -> void:
	for child in get_children():
		tile_dictionary[child.tile_area_position] = child

func new_tile_entered(tile : Vector2) -> void:
	await get_tree().process_frame
	await get_tree().physics_frame
	if(tile_dictionary.has(tile)):
		if(tile_dictionary[tile].tile_area_position == tile):
			if(first_tile_loaded):
				await stall_room_loading(tile_dictionary[tile])
			tile_dictionary[tile].tile_entered(tile)
			current_tile = tile
	else:
		current_tile = Vector2.INF

func stall_room_loading(tile_to_load : TileArea) -> void:
	await get_tree().process_frame

func player_tile_entered(new_tile_position : Vector2) -> void:
	new_tile_entered(new_tile_position)

func player_tile_left(new_tile_position : Vector2) -> void:
	if(tile_dictionary.has(current_tile)):
			tile_dictionary[current_tile].tile_exited(new_tile_position)
