extends StaticBody2D

@export var secret_found_sound : AudioStreamWAV = load("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Magical.wav")

func _on_hitbox_area_entered(area: Area2D) -> void:
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	$Hitbox/CollisionShape2D.disabled = true
	$AudioStreamPlayer.stream = secret_found_sound
	$AudioStreamPlayer.play(0.0)
	while $AudioStreamPlayer.playing:
		await get_tree().process_frame
	queue_free()
