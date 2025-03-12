extends CharacterBody2D

class_name EnemyAI

@export var enemy_type : ENUM.ENEMY_TYPE
@export var hitbox_attack_block_level : ENUM.BLOCK_ATTACK_LEVEL = ENUM.BLOCK_ATTACK_LEVEL.IMPOSSIBLE
@export var max_health : int = 1
@export var attacked_iframes : int = 16
@export var attack_contact_damage : int = 1
@export var has_knockback : bool
@export var attacked_knockback_force : float = 140
@export var attacked_knockback_duration : float = .2
var is_attacked_knockback : bool
var knockback_distance : float = 4
var current_attacked_iframes : float
var boomerang_freeze_time : float = 3
var current_boomerang_freeze_time : float = 0
var is_boomerang_frozen : bool
var current_health : int
var last_player_authority : PlayerData
@export_flags_2d_physics var collision_layers_bitmask

var link : LinkController
var death_scene : PackedScene = load("res://scenes/enemy_death.tscn")
var camera
signal was_attacked
signal has_died

func _ready() -> void:
	current_health = max_health
	camera = get_tree().get_first_node_in_group("Camera")
	link = get_tree().get_first_node_in_group("Player")
	
func _process(delta: float) -> void:
	current_attacked_iframes -= delta
	if(is_boomerang_frozen):
		current_boomerang_freeze_time -= delta
		if(current_boomerang_freeze_time <= 0):
			is_boomerang_frozen = false
	
func _on_area_entered(area: Area2D) -> void:
	if(area is PlayerAttack):
		if(area is Boomerang):
			boomerang_freeze()
		else:
			attacked(area.get_attack_damage(), area.global_position, area.get_authority())

func attacked(damage : int, from : Vector2, authority : PlayerData) -> void:
	if(current_attacked_iframes > 0):
		return
	last_player_authority = authority
	current_attacked_iframes = attacked_iframes / 60.0
	current_health -= damage
	was_attacked.emit()
	if(has_knockback):
		knockback(from)
	
	$AnimatedSprite2D.hit_effect()
	if(current_health <= 0):
		death()
	else:
		play_hurt_sound()

func play_hurt_sound() -> void:
	var sfx_player : SFXPlayer = get_tree().get_first_node_in_group("SFXPlayer")
	sfx_player.play_sound(SFXPlayer.SFX.ENEMY_HURT)

func play_death_sound() -> void:
	var sfx_player : SFXPlayer = get_tree().get_first_node_in_group("SFXPlayer")
	sfx_player.play_sound(SFXPlayer.SFX.ENEMY_DEATH)

func knockback(from : Vector2) -> void:
	if(is_attacked_knockback):
		return
	is_attacked_knockback = true
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
		velocity = knockback_direction * attacked_knockback_force
		move_and_slide()
		await get_tree().process_frame
	
	is_attacked_knockback = false

func get_knockback_direction(from : Vector2) -> Vector2:
	var character_centre = global_position + Vector2(8, 8)
	var hit_centre = from
	var hit_direction = (hit_centre - character_centre).normalized()
	return get_cardinal_direction(-hit_direction)

func get_cardinal_direction(direction: Vector2) -> Vector2:
	var directions = {
		Vector2.UP: Vector2.UP,
		Vector2.DOWN: Vector2.DOWN,
		Vector2.LEFT: Vector2.LEFT,
		Vector2.RIGHT: Vector2.RIGHT
	}

	var max_dot = -1.0
	var best_match = Vector2.ZERO
	
	for dir in directions.keys():
		var dot = direction.dot(dir)
		if dot > max_dot:
			max_dot = dot
			best_match = dir
	
	return best_match

func can_move() -> bool:
	if GameSettings.camera_is_moving or !can_process() or is_boomerang_frozen or is_attacked_knockback:
		return false
	return true

func boomerang_freeze() -> void:
	current_boomerang_freeze_time = boomerang_freeze_time
	is_boomerang_frozen = true

func death() -> void:
	var death_object = death_scene.instantiate()
	get_parent().get_parent().add_child(death_object)
	death_object.global_position = global_position
	death_object.set_player_authority(last_player_authority)
	last_player_authority.add_player_kill(enemy_type, ENUM.KILL_METHOD.OTHER)
	play_death_sound()
	has_died.emit()
	queue_free()
