extends Node2D

class_name Boomerang

enum BOOMERANG_TYPE { WOODEN, MAGICAL }

var move_direction : Vector2
var camera
@export var move_speed : float = 140
@export var hit_effect_wait_time : float = 0.1
var hit_something : bool = false
var boomerang_type : BOOMERANG_TYPE
var boomerang_thrower : Node2D
var return_to_thrower : bool
var wooden_boomerang_throw_distance : float = 4
var current_travel_distance : float
var thrower_position_offset : Vector2 = Vector2(8,8)
var use_thrower_position_offset : bool
signal boomerang_picked_up

func initialize_boomerang(type : BOOMERANG_TYPE, direction : Vector2, camera_object : Camera2D, thrower : Node2D, use_position_offset : bool) -> void:
	boomerang_thrower = thrower
	use_thrower_position_offset = use_position_offset
	boomerang_type = type
	camera = camera_object
	match type:
		BOOMERANG_TYPE.WOODEN:
			$AnimatedSprite2D.play("wooden")
		BOOMERANG_TYPE.MAGICAL:
			$AnimatedSprite2D.play("magical")
	move_direction = direction
	play_sound()
	
func _process(delta: float) -> void:
	check_screen_bounds()
	if(!hit_something and !return_to_thrower):
		var travel_distance =  move_direction * move_speed * get_process_delta_time()
		global_position += travel_distance
		current_travel_distance += abs(travel_distance.length())
		if(boomerang_type == BOOMERANG_TYPE.WOODEN and current_travel_distance >= wooden_boomerang_throw_distance * 16):
			return_to_thrower = true
	if(return_to_thrower):
		var boomerang_thrower_position = boomerang_thrower.global_position
		if(use_thrower_position_offset):
			boomerang_thrower_position += thrower_position_offset
		var direction_to_thrower : Vector2 = (global_position - boomerang_thrower_position).normalized()
		global_position += -direction_to_thrower * move_speed * get_process_delta_time()
		if(global_position.distance_to(boomerang_thrower_position) <= 1):
			boomerang_picked_up.emit()
			stop_sound()
			queue_free()

func play_sound() -> void:
	get_tree().get_first_node_in_group("SFXPlayer").loop_sound(SFXPlayer.SFX.BOOMERANG)

func stop_sound() -> void:
	get_tree().get_first_node_in_group("SFXPlayer").stop()

func check_screen_bounds() -> void:
	if(Utils.is_out_of_bounds(global_position, camera, true) and !return_to_thrower):
		hit_effect()

func hit_effect() -> void:
	hit_something = true
	$AnimatedSprite2D.play("hit")
	$CollisionShape2D.call_deferred("set_disabled", true)
	await get_tree().create_timer(hit_effect_wait_time).timeout
	match boomerang_type:
		BOOMERANG_TYPE.WOODEN:
			$AnimatedSprite2D.play("wooden")
		BOOMERANG_TYPE.MAGICAL:
			$AnimatedSprite2D.play("magical")
	return_to_thrower = true

func _on_area_entered(area: Area2D) -> void:
	hit_effect()
