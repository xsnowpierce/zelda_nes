extends Node

@export var attacked_iframes : float = 16
var current_attacked_iframes : float
@export var attacked_knockback_force : float = 140
@export var attacked_knockback_duration : float = .2
@export var max_block_angle : float = 40
var player : CharacterBody2D
signal play_sword_swing_sound
signal play_shield_block_sound
signal play_attacked_sound
signal sword_swing_attack

func initialize(parent: CharacterBody2D) -> void:
	player = parent

func process(delta: float) -> void:
	current_attacked_iframes -= delta
	if(!GameSettings.camera_is_moving):
		check_attack()

func check_attack() -> void:
	if(!player.get_player_state().is_player_input_allowed()):
		return
	if(Input.is_action_just_pressed("attack") and !player.get_player_state().is_attacking):
		use_weapon(player.game_data.current_equipped_item_a)
	if(Input.is_action_just_pressed("alternate_attack") and !player.get_player_state().is_attacking):
		use_weapon(player.game_data.current_equipped_item_b)

func use_weapon(item : ENUM.KEY_ITEM_TYPE) -> void:
	if(item == ENUM.KEY_ITEM_TYPE.NULL):
		return
	match item:
		ENUM.KEY_ITEM_TYPE.WOODEN_SWORD:
			wooden_sword_swing()
		_:
			player.use_alt_weapon(item)
			

func wooden_sword_swing() -> void:
	player.get_player_state().is_attacking = true
	sword_swing_attack.emit()
	play_sword_swing_sound.emit()

func _on_animated_sprite_2d_attack_ended() -> void:
	player.get_player_state().is_attacking = false

func attacked(damage : int, from : Vector2, attack_block_level : ENUM.BLOCK_ATTACK_LEVEL = ENUM.BLOCK_ATTACK_LEVEL.IMPOSSIBLE) -> void:
	if(try_block_attack(from, attack_block_level)):
		play_shield_block_sound.emit()
		return
	
	if(current_attacked_iframes > 0):
		return
	
	current_attacked_iframes = (attacked_iframes / 60)
	player.get_player_state().is_attacked_knockback = true
	player.get_sprite().hit_effect()
	play_attacked_sound.emit()
	player.game_data.player_took_damage(damage)
	var knockback_direction : Vector2 = get_knockback_direction(from)
	if(abs(knockback_direction.x) > abs(knockback_direction.y)):
		knockback_direction.y = 0
		if(knockback_direction.x > 0):
			knockback_direction.x = 1
		else:
			knockback_direction.x = -1
	else: 
		knockback_direction.x = 0
		if(knockback_direction.y > 0):
			knockback_direction.y = 1
		else:
			knockback_direction.y = -1
	
	var knockbacktimer : float = 0
	while (knockbacktimer < attacked_knockback_duration):
		knockbacktimer += get_process_delta_time()
		player.velocity = knockback_direction * attacked_knockback_force
		player.move_and_slide()
		await get_tree().process_frame
	
	player.get_player_state().is_attacked_knockback = false

func get_knockback_direction(from : Vector2) -> Vector2:
	var link_centre = player.global_position + Vector2(8, 8)
	var hit_centre = from + Vector2(8, 8)
	var hit_direction = (hit_centre - link_centre).normalized()
	
	var link_facing_degrees = rad_to_deg(player.get_look_direction().angle())
	
	var angle_rad : float = player.global_position.angle_to_point(hit_centre)
	var direction : Vector2 = Vector2(cos(angle_rad), sin(angle_rad)).normalized()
	return -direction
	

func try_block_attack(from: Vector2, block_level: ENUM.BLOCK_ATTACK_LEVEL = ENUM.BLOCK_ATTACK_LEVEL.IMPOSSIBLE) -> bool:
	if block_level == ENUM.BLOCK_ATTACK_LEVEL.IMPOSSIBLE:
		return false
	if block_level == ENUM.BLOCK_ATTACK_LEVEL.MAGICAL_SHIELD and not player.game_data.has_player_flag("obtained_magical_shield"):
		return false
	
	var link_centre = player.global_position + Vector2(8, 8)
	var hit_centre = from + Vector2(8, 8)
	var hit_direction = (hit_centre - link_centre).normalized()
	
	var link_facing_degrees = rad_to_deg(player.get_look_direction().angle())
	
	var attacking_degrees = rad_to_deg(player.global_position.angle_to_point(hit_centre))
	
	return abs(link_facing_degrees - attacking_degrees) <= max_block_angle


func _on_link_hitbox_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Enemy")):
		if(area.get_parent() is EnemyAI):
			attacked(area.get_parent().attack_contact_damage, area.get_parent().global_position, area.get_parent().hitbox_attack_block_level)
		else:
			attacked(1, area.global_position, ENUM.BLOCK_ATTACK_LEVEL.IMPOSSIBLE)
	if(area.is_in_group("Enemy_Attack")):
		if(area is EnemyProjectile):
			attacked(area.attack_contact_damage, area.global_position, area.attack_block_level)
		else:
			attacked(area.get_attack_damage(), area.global_position, area.hitbox_attack_block_level)
