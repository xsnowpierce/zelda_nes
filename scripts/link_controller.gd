extends CharacterBody2D

var game_data : Node
var camera : Camera2D

func _ready() -> void:
	game_data = get_tree().get_first_node_in_group("GameData")
	camera = get_tree().get_first_node_in_group("Camera")
	$LinkMovement.initialize(self)
	$LinkCombat.initialize(self)
	$LinkInteract.initialize(self)
	$LinkState.initialize(self)
	$"Link AltWeapon".initialize(self)

func _process(delta: float) -> void:
	$LinkCombat.process(delta)
	$LinkMovement.process(delta)
	$LinkInteract.process(delta)
	$"Link AltWeapon".process(delta)

func get_player_state() -> Node:
	return $LinkState

func get_look_direction() -> Vector2:
	return $"Link Sprite Mask/Link Sprite".current_direction

func attacked(from : Vector2, attack_block_level : ENUM.BLOCK_ATTACK_LEVEL = ENUM.BLOCK_ATTACK_LEVEL.IMPOSSIBLE) -> void:
	$LinkCombat.attacked(from, attack_block_level)

func get_sprite_mask() -> Control:
	return $"Link Sprite Mask"

func get_sprite() -> AnimatedSprite2D:
	return $"Link Sprite Mask/Link Sprite"

func get_link_interact() -> Node:
	return $LinkInteract

func use_alt_weapon(item : ENUM.KEY_ITEM_TYPE) -> void:
	$"Link AltWeapon".use_alternate_weapon(item)
