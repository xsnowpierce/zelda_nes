extends Node2D

@export var explosion_wait_time : float = 0.6

func _ready() -> void:
	await get_tree().create_timer(explosion_wait_time).timeout
	explode()

func explode() -> void:
	$"Bomb Sprite".visible = false
	$AnimationPlayer.active = true
	$AnimationPlayer.play("bomb_explode")
	while($AnimationPlayer.is_playing()):
		await get_tree().process_frame
	queue_free()
