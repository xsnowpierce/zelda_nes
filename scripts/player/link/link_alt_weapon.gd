extends Node

var player : LinkController

var spawn_projectile_distance : float = 1
@export_group("Scenes")
@export var bomb_scene : PackedScene = preload("res://scenes/bomb.tscn")
@export var candle_flame_scene : PackedScene = preload("res://scenes/candle_fire.tscn")
@export var magical_wand_scene : PackedScene = preload("res://scenes/magical_wand_beam.tscn")
@export var wooden_arrow_scene : PackedScene = preload("res://scenes/wooden_arrow.tscn")
@export var boomerang_scene : PackedScene = preload("res://scenes/boomerang.tscn")
@export var food_item_scene : PackedScene = preload("res://scenes/food.tscn")
var current_projectile
var current_food
@export_group("")
@export var whistle_pause_time : float = 2.7

func initialize(parent : LinkController) -> void:
	player = parent

func process(delta: float) -> void:
	pass

func use_alternate_weapon(item : ENUM.KEY_ITEM_TYPE) -> void:
	match item:
		ENUM.KEY_ITEM_TYPE.BOMB:
			if(is_instance_valid(current_projectile)):
				return
			if(player.game_data.current_bombs <= 0):
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
		ENUM.KEY_ITEM_TYPE.WOODEN_ARROW:
			if(is_instance_valid(current_projectile)):
				return
			if(player.game_data.current_rupees <= 0):
				return
			var arrow = wooden_arrow_scene.instantiate()
			arrow.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
			player.game_data.add_child(arrow)
			arrow.initialize_arrow(player.get_look_direction(), player.camera)
			current_projectile = arrow
			player.use_item_animation()
			player.game_data.change_rupees(-1)
		ENUM.KEY_ITEM_TYPE.RECORDER:
			player.game_data.set_whistle_pause_value(true)
			get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.WHISTLE_MUSIC)
			await get_tree().create_timer(whistle_pause_time).timeout
			player.played_flute.emit()
			player.game_data.set_whistle_pause_value(false)
		ENUM.KEY_ITEM_TYPE.WOODEN_BOOMERANG:
			if(is_instance_valid(current_projectile)):
				return
			if(is_instance_valid(current_food)):
				current_food.queue_free()
			var boomerang = boomerang_scene.instantiate()
			boomerang.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
			player.game_data.add_child(boomerang)
			boomerang.initialize_boomerang(Boomerang.BOOMERANG_TYPE.WOODEN, player.get_look_direction(), player.camera, player, false)
			current_projectile = boomerang
			boomerang.connect("boomerang_picked_up", Callable(self, "boomerang_pickup"))
			player.use_item_animation()
		ENUM.KEY_ITEM_TYPE.MAGICAL_BOOMERANG:
			if(is_instance_valid(current_projectile)):
				return
			var boomerang = boomerang_scene.instantiate()
			boomerang.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
			player.game_data.add_child(boomerang)
			boomerang.initialize_boomerang(Boomerang.BOOMERANG_TYPE.MAGICAL, player.get_look_direction(), player.camera, player, false)
			current_projectile = boomerang
			boomerang.connect("boomerang_picked_up", Callable(self, "boomerang_pickup"))
			player.use_item_animation()
		ENUM.KEY_ITEM_TYPE.FOOD:
			if(is_instance_valid(current_food)):
				return
			var food = food_item_scene.instantiate()
			food.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
			player.game_data.add_child(food)
			current_food = food
			player.food_placed.emit(food.global_position)
			player.use_item_animation()

func cast_magical_wand_beam() -> void:
	var wand_beam = magical_wand_scene.instantiate()
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.MAGICAL_WAND_SHOOT)
	player.game_data.add_child(wand_beam)
	wand_beam.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
	wand_beam.initialize_beam(player.get_look_direction(), player.camera)
	current_projectile = wand_beam

func boomerang_pickup() -> void:
	player.use_item_animation()
