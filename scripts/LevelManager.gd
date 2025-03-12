extends Node

class_name LevelManager

var _loaded_tiles : Dictionary[Vector2i, int]
@export var _tile_holders : Array[Node]
var _tile_area_map : Dictionary[Vector2i, TileArea]
signal tile_moved

func _enter_tree() -> void:
	for array in _tile_holders:
		for child in array.get_children():
			if(child is TileArea):
				var area_position : Vector2i = Vector2i(floori(child.global_position.x / 16 / 16), floori(child.global_position.y / 16 / 11))
				_tile_area_map[area_position] = child
			else:
				printerr("Tried to load non TileArea object as a tile. Object name: ", child.name)
				continue

func player_left_tile(tile : Vector2i) -> void:
	print("player left ", tile)
	if(!_loaded_tiles.has(tile)):
		return
	_loaded_tiles[tile] -= 1
	if(_loaded_tiles[tile] <= 0):
		unload_tile(tile)
		_loaded_tiles.erase(tile)

func load_tile(tile : Vector2i) -> void:
	if(_tile_area_map.has(tile)):
		_tile_area_map[tile].tile_entered()

func unload_tile(tile : Vector2i) -> void:
	if(_tile_area_map.has(tile)):
		_tile_area_map[tile].tile_exited()

func player_entered_tile(tile : Vector2i) -> void:
	print("player entered ", tile)
	if(!_loaded_tiles.has(tile)):
		_loaded_tiles[tile] = 1
		load_tile(tile)
	else:
		_loaded_tiles[tile] += 1

func get_loaded_tiles() -> Dictionary[Vector2i, int]:
	return _loaded_tiles

func get_tile_area_map() -> Dictionary[Vector2i, TileArea]:
	return _tile_area_map
