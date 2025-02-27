extends Node

var player : CharacterBody2D

var spawn_projectile_distance : float = 1
@export var bomb_scene : PackedScene = preload("res://scenes/bomb.tscn")
@export var candle_flame_scene : PackedScene = preload("res://scenes/candle_fire.tscn")
@export var magical_wand_scene : PackedScene = preload("res://scenes/magical_wand_beam.tscn")
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
		ENUM.KEY_ITEM_TYPE.MAGICAL_ROD:
			if(is_instance_valid(current_projectile)):
				return
			player.get_player_state().is_shooting_magical_wand = true
			player.get_sprite().on_magical_wand_cast()

func cast_magical_wand_beam() -> void:
	var wand_beam = magical_wand_scene.instantiate()
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.MAGICAL_WAND_SHOOT)
	player.game_data.add_child(wand_beam)
	wand_beam.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
	wand_beam.initialize_beam(player.get_look_direction(), player.camera)
	current_projectile = wand_beam
