extends Area2D

@export var up_position : Vector2 = Vector2(0, -14)
@export var down_position : Vector2 = Vector2(0, 14)
@export var left_position : Vector2 = Vector2(-14, 0)
@export var right_position : Vector2 = Vector2(14, 0)

func set_direction(direction : Vector2) -> void:
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
