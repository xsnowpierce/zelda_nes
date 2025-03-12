extends Area2D

class_name PlayerAttack

@export var attack_damage : int = 1
var player_authority : PlayerData

func get_attack_damage() -> int:
	return attack_damage

func get_authority() -> PlayerData:
	return player_authority
