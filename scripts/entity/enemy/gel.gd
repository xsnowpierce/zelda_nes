extends EnemyAI_Wander
	
func moved_a_tile() -> void:
	if(randf_range(0, 1) >= 0.5):
		await get_tree().create_timer(0.05).timeout
	else: 
		await get_tree().create_timer(.5).timeout
