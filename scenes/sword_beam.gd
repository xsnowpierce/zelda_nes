extends PlayerAttack

var move_direction : Vector2
var camera
var sword_beam_hit_scene : PackedScene = load("res://scenes/sword_beam_hit.tscn")
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
		hit_target()

func hit_target() -> void:
	var beam_hit = sword_beam_hit_scene.instantiate()
	get_parent().add_child(beam_hit)
	beam_hit.global_position = global_position
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	hit_target()
