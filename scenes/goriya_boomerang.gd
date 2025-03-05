extends Boomerang

@export var hitbox_attack_block_level : ENUM.BLOCK_ATTACK_LEVEL = ENUM.BLOCK_ATTACK_LEVEL.IMPOSSIBLE

func play_sound() -> void:
	pass

func stop_sound() -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player")):
		hit_effect()
