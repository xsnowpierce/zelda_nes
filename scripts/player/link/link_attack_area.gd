extends PlayerAttack

@export var up_position : Vector2 = Vector2(0, -14)
@export var down_position : Vector2 = Vector2(0, 14)
@export var left_position : Vector2 = Vector2(-14, 0)
@export var right_position : Vector2 = Vector2(14, 0)
var link : LinkController

func initialize(player : LinkController) -> void:
	link = player
	player_authority = player.get_parent()

func set_direction(direction : Vector2, velocity : Vector2) -> void:
	if(direction == Vector2.ZERO):
		return
	match direction.normalized():
		Vector2.UP:
			position = up_position
		Vector2.DOWN:
			position = down_position
		Vector2.LEFT:
			position = left_position
		Vector2.RIGHT:
			position = right_position

func set_collider_enabled(value : bool) -> void:
	monitorable = value
	monitoring = value


func _on_link_attack() -> void:
	set_collider_enabled(true)


func _on_link_sprite_attack_ended() -> void:
	set_collider_enabled(false)

func get_attack_damage() -> int:
	match(link.player_data.current_equipped_item_a):
		ENUM.ITEM_TYPE.WOODEN_SWORD:
			return 2
		ENUM.ITEM_TYPE.WHITE_SWORD:
			return 4
		ENUM.ITEM_TYPE.MAGICAL_SWORD:
			return 6
	return 1
