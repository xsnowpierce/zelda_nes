extends Node

@export var enemy_tektite_scene : PackedScene
@export var enemy_octorok_scene : PackedScene

var max_player_health : int = 6
var current_player_health : int = 6

signal player_death
signal player_health_changed(new_current_amount : int)
signal player_max_health_changed(new_max_amount : int)

func _ready() -> void:
	player_max_health_changed.emit(max_player_health)
	player_health_changed.emit(current_player_health)

func player_took_damage(damage : int) -> void:
	player_lose_health(damage)
	if(current_player_health <= 0):
		player_death.emit()

func player_gain_heart(amount : int) -> void:
	current_player_health += amount
	player_health_changed.emit(current_player_health)

func player_lose_health(amount : int) -> void:
	current_player_health -= amount
	player_health_changed.emit(current_player_health)

func change_max_hearts(amount : int) -> void:
	max_player_health += amount
	if(current_player_health > max_player_health):
		current_player_health = max_player_health
	player_max_health_changed.emit(max_player_health)
