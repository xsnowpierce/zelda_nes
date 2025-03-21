extends CharacterBody2D

class_name LinkController

var game_data : GameData
var camera : Camera2D

signal played_flute
signal force_walk_completed
signal food_placed(place_location : Vector2)

func _ready() -> void:
	game_data = get_tree().get_first_node_in_group("GameData")
	camera = get_tree().get_first_node_in_group("Camera")
	$LinkMovement.initialize(self)
	$LinkCombat.initialize(self)
	$LinkInteract.initialize(self)
	$LinkState.initialize(self)
	$"Link AltWeapon".initialize(self)
	$"Attack Area".initialize(self)
	$"Link Sprite Mask/Link Sprite".connect("cast_magical_wand", Callable(self, "cast_magical_wand_beam"))
	$"Link Sprite Mask/Link Sprite".connect("magical_wand_cast_ended", Callable(self, "magical_wand_cast_ended"))
	
func _process(delta: float) -> void:
	$LinkCombat.process(delta)
	$LinkMovement.process(delta)
	$LinkInteract.process(delta)
	$"Link AltWeapon".process(delta)

func get_player_state() -> LinkState:
	return $LinkState

func get_look_direction() -> Vector2:
	return get_sprite().current_direction

func get_movement_value() -> Vector2:
	return $LinkMovement.movement

func get_sprite_mask() -> Control:
	return $"Link Sprite Mask"

func get_sprite() -> LinkSprite:
	return $"Link Sprite Mask/Link Sprite"

func get_link_interact() -> Node:
	return $LinkInteract

func use_alt_weapon(item : ENUM.ITEM_TYPE) -> void:
	$"Link AltWeapon".use_alternate_weapon(item)
	
func use_item_animation() -> void:
	get_player_state().is_placing_item = true
	await get_sprite().play_placing_item_animation()
	get_player_state().is_placing_item = false

func cast_magical_wand_beam() -> void:
	$"Link AltWeapon".cast_magical_wand_beam()

func magical_wand_cast_ended() -> void:
	get_player_state().is_shooting_magical_wand = false

func new_tile_entered(new_area_position : Vector2) -> void:
	get_player_state().is_entering_new_tile = true
	if(game_data.is_inside_dungeon):
		await $LinkMovement.force_player_walk()
	get_player_state().is_entering_new_tile = false

func get_player_global_tile_position() -> Vector2:
	var collider_centre = $"Link Collider".global_position
	collider_centre.x /= 16
	collider_centre.y /= 11
	return Vector2(floori(collider_centre.x), floori(collider_centre.y))

func get_player_camera_relative_tile_position() -> Vector2:
	var collider_centre = $"Link Collider".global_position
	collider_centre -= camera.global_position
	collider_centre.x /= 16
	collider_centre.y /= 11
	return Vector2(floori(collider_centre.x), floori(collider_centre.y))

func pickup_key_item_animation(item : ENUM.ITEM_TYPE) -> void:
	$LinkInteract.picked_up_key_item(item)

func get_pickup_item_sprite() -> LinkPickupItemSprite:
	return $pickup_item_sprite
