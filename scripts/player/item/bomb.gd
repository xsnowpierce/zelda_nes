extends PlayerAttack

@export var explosion_wait_time : float = 1

func _ready() -> void:
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.BOMB_EXPLOSION)
	await get_tree().create_timer(explosion_wait_time).timeout
	explode()

func explode() -> void:
	$"Bomb Sprite".visible = false
	$AnimationPlayer.active = true
	$AnimationPlayer.play("bomb_explode")
	
	monitoring = true
	monitorable = true
	$CollisionPolygon2D.disabled = false
	while($AnimationPlayer.is_playing()):
		await get_tree().process_frame
	queue_free()
