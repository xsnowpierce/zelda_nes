extends EnemyAI_Wander

@export var random_shoot_time_range : Vector2 = Vector2(1.5,2.5)
@export var shoot_delay_time : float = 0.3
@export var post_shoot_delay_move_time : float = 0.1
var projectile_scene : PackedScene = load("res://scenes/octorok_rock.tscn")
var current_shoot_time : float
var is_shooting : bool = false

func _ready() -> void:
	super()
	current_shoot_time = randf_range(random_shoot_time_range.x, random_shoot_time_range.y)

func _process(delta: float) -> void:
	super(delta)
	current_shoot_time -= delta
	if(current_shoot_time <= 0 and can_move()):
		shoot_projectile()
		current_shoot_time = randf_range(random_shoot_time_range.x, random_shoot_time_range.y)

func should_move() -> bool:
	if(!is_moving and !is_shooting):
		return true
	return false
		
func shoot_projectile() -> void:
	is_shooting = true
	var current_shoot_delay_time = shoot_delay_time
	while current_shoot_delay_time > 0:
		current_shoot_delay_time -= get_process_delta_time()
		await get_tree().process_frame
	spawn_projectile()
	var current_post_delay : float = post_shoot_delay_move_time
	while current_post_delay > 0:
		current_post_delay -= get_process_delta_time()
		await get_tree().process_frame
	is_shooting = false

func spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.position = position + (current_forward_vector * 16)
	projectile.set_forward_vector(current_forward_vector)
