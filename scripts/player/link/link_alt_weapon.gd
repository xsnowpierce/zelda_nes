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
@export var full_hp_sword_projectile : PackedScene = preload("res://scenes/sword_beam.tscn")
var current_projectile
var current_food
@export_group("")
@export var whistle_pause_time : float = 2.7
@export var full_hp_sword_beam_cooldown : float = 1
var current_sword_beam_cooldown : float

func initialize(parent : LinkController) -> void:
	player = parent

func process(delta: float) -> void:
	if(current_sword_beam_cooldown > 0):
		current_sword_beam_cooldown -= delta

func use_alternate_weapon(item : ENUM.ITEM_TYPE) -> void:
	match item:
		ENUM.ITEM_TYPE.BOMB:
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
		ENUM.ITEM_TYPE.BLUE_CANDLE:
			if(is_instance_valid(current_projectile)):
				return
			var flame = candle_flame_scene.instantiate()
			flame.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
			player.game_data.add_child(flame)
			flame.initialize_fire(player.get_look_direction())
			current_projectile = flame
			player.use_item_animation()
		ENUM.ITEM_TYPE.MAGICAL_ROD:
			if(is_instance_valid(current_projectile)):
				return
			player.get_player_state().is_shooting_magical_wand = true
			player.get_sprite().on_magical_wand_cast()
		ENUM.ITEM_TYPE.WOODEN_ARROW:
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
		ENUM.ITEM_TYPE.RECORDER:
			player.game_data.set_whistle_pause_value(true)
			get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.WHISTLE_MUSIC)
			await get_tree().create_timer(whistle_pause_time).timeout
			player.played_flute.emit()
			player.game_data.set_whistle_pause_value(false)
		ENUM.ITEM_TYPE.WOODEN_BOOMERANG:
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
		ENUM.ITEM_TYPE.MAGICAL_BOOMERANG:
			if(is_instance_valid(current_projectile)):
				return
			var boomerang = boomerang_scene.instantiate()
			boomerang.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
			player.game_data.add_child(boomerang)
			boomerang.initialize_boomerang(Boomerang.BOOMERANG_TYPE.MAGICAL, player.get_look_direction(), player.camera, player, false)
			current_projectile = boomerang
			boomerang.connect("boomerang_picked_up", Callable(self, "boomerang_pickup"))
			player.use_item_animation()
		ENUM.ITEM_TYPE.FOOD:
			if(is_instance_valid(current_food)):
				return
			var food = food_item_scene.instantiate()
			food.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
			player.game_data.add_child(food)
			current_food = food
			player.food_placed.emit(food.global_position)
			player.use_item_animation()
		_:
			print("Tried to attack with unhandled item type: (", str(item), ", ", ENUM.ITEM_TYPE.keys()[item] ,")")

func cast_magical_wand_beam() -> void:
	var wand_beam = magical_wand_scene.instantiate()
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.MAGICAL_WAND_SHOOT)
	player.game_data.add_child(wand_beam)
	wand_beam.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
	wand_beam.initialize_beam(player.get_look_direction(), player.camera)
	current_projectile = wand_beam

func boomerang_pickup() -> void:
	player.use_item_animation()

func _on_link_combat_full_health_sword_swing() -> void:
	if(is_instance_valid(current_projectile) or current_sword_beam_cooldown > 0):
		return
	var sword_beam = full_hp_sword_projectile.instantiate()
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.SWORD_BEAM)
	player.game_data.add_child(sword_beam)
	sword_beam.global_position = (player.global_position) + (player.get_look_direction() * (spawn_projectile_distance * 16))
	sword_beam.initialize_beam(player.get_look_direction(), player.camera)
	current_projectile = sword_beam
	current_sword_beam_cooldown = full_hp_sword_beam_cooldown
