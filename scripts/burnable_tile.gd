extends "res://scripts/entity.gd"

signal was_burned

func _on_hitbox_area_entered(area: Area2D) -> void:
	if(!is_awake):
		return
	if(area.is_in_group("Player_Fire")):
		was_burned.emit()
		queue_free()
