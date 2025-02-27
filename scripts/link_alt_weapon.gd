extends Node

var player : CharacterBody2D

var spawn_projectile_distance : float = 1
@export var bomb_scene : PackedScene = preload("res://scenes/bomb.tscn")
@export var candle_flame_scene : PackedScene = preload("res://scenes/candle_fire.tscn")
var current_projectile

func initialize(parent : CharacterBody2D) -> void:
	player = parent

func process(delta: float) -> void:
	pass

func use_alternate_weapon(item : ENUM.KEY_ITEM_TYPE) -> void:
	match item:
		ENUM.KEY_ITEM_TYPE.BOMB:
			if(is_instance_valid(current_projectile)):
				return
			var bomb = bomb_scene.instantiate()
			bomb.global_position = (player.global_position - Vector2(8,8)) + (player.get_look_direction() * (spawn_projectile_distance * 16))
			current_projectile = bomb
			player.game_data.add_child(bomb)
			player.game_data.change_bombs(-1)
			player.use_item_animation()
		ENUM.KEY_ITEM_TYPE.BLUE_CANDLE:
			if(is_instance_valid(current_projectile)):
				return
			var flame = candle_flame_scene.instantiate()
			flame.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
			player.game_data.add_child(flame)
			flame.initialize_fire(player.get_look_direction())
			current_projectile = flame
			player.use_item_animation()
