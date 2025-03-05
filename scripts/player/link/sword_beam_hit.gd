extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("sword_beam")
	while $AnimationPlayer.is_playing():
		await get_tree().process_frame
	queue_free()
