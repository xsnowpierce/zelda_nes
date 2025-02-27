extends Area2D

class_name EnemyAI

@export var enemy_type : ENUM.ENEMY_TYPE
@export var hitbox_attack_block_level : ENUM.BLOCK_ATTACK_LEVEL = ENUM.BLOCK_ATTACK_LEVEL.IMPOSSIBLE
@export var max_health : int = 1
@export var attacked_iframes : int = 16
var current_attacked_iframes : float
var current_health : int
@export_flags_2d_physics var collision_layers_bitmask

var link : CharacterBody2D
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
	
func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player_Attack")):
		attacked()
	elif(area.is_in_group("Player")):
		get_tree().get_first_node_in_group("Player").attacked(global_position, hitbox_attack_block_level)

func attacked() -> void:
	if(current_attacked_iframes > 0):
		return
	current_attacked_iframes = attacked_iframes / 60.0
	current_health -= 1
	was_attacked.emit()
	var sfx_player : SFXPlayer = get_tree().get_first_node_in_group("SFXPlayer")
	sfx_player.play_sound(SFXPlayer.SFX.ENEMY_DEATH)
	if(current_health <= 0):
		death()

func death() -> void:
	var death_object = death_scene.instantiate()
	get_parent().add_child(death_object)
	death_object.global_position = global_position
	get_tree().get_first_node_in_group("GameData").add_player_kill(enemy_type, ENUM.KILL_METHOD.OTHER)
	has_died.emit()
	queue_free()
