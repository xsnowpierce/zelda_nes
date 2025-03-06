extends "res://scripts/world/tile_area_controller.gd"

func _ready() -> void:
	super()

func stall_room_loading(tile_to_load : TileArea) -> void:
	if(tile_to_load is DungeonTileArea):
		var link : LinkController = get_tree().get_first_node_in_group("Player")
		await link.force_walk_completed
