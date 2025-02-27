extends Node2D

var move_direction : Vector2
var camera
var fire_scene : PackedScene = load("res://scenes/candle_fire.tscn")
@export var move_speed : float = 140

func initialize_beam(direction : Vector2, camera_object : Camera2D) -> void:
	camera = camera_object
	match direction:
		Vector2.RIGHT:
			$AnimatedSprite2D.play("right")
		Vector2.LEFT:
			$AnimatedSprite2D.play("left")
		Vector2.UP:
			$AnimatedSprite2D.play("up")
		Vector2.DOWN:
			$AnimatedSprite2D.play("down")
	move_direction = direction
	
func _process(delta: float) -> void:
	check_screen_bounds()
	global_position += move_direction * move_speed * get_process_delta_time()

func check_screen_bounds() -> void:
	if(Utils.is_out_of_bounds(global_position, camera, false)):
		spawn_fire()
		queue_free()

func spawn_fire() -> void:
	var fire_object = fire_scene.instantiate()
	get_tree().get_first_node_in_group("GameData").add_child(fire_object)
	fire_object.global_position = global_position
	fire_object.initialize_fire(Vector2.ZERO)

func _on_area_2d_area_entered(area: Area2D) -> void:
	global_position = area.global_position + Vector2(8, 8)
	spawn_fire()
	queue_free()
