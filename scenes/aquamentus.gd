extends EnemyAI

var fireball_01_direction : float = -20
var fireball_02_direction : float = 0
var fireball_03_direction : float = 20
var fireball_scene : PackedScene = load("res://scenes/zora_ball.tscn")

@export var move_speed : float
@export var random_shoot_timer : Vector2 = Vector2(1, 3)
@export var random_innacuracy_range_degrees : Vector2 = Vector2(-5, 5)
@export var shoot_delay : float = 0.4
@export var roar_sound_delay : float = 3
var current_shoot_timer : float
var is_shooting : bool

func _ready() -> void:
	link = get_tree().get_first_node_in_group("Player")
	current_shoot_timer = randf_range(random_shoot_timer.x, random_shoot_timer.y)
	play_roar_sound()

func _process(delta: float) -> void:
	super(delta)
	current_shoot_timer -= delta
	if(current_shoot_timer <= 0 and !is_shooting):
		shoot_projectile()

func shoot_projectile() -> void:
	is_shooting = true
	$AnimatedSprite2D.play("mouth_open")
	await get_tree().create_timer(shoot_delay).timeout
	$AnimatedSprite2D.play("default")
	
	var fireball_directions = [fireball_01_direction, fireball_02_direction, fireball_03_direction]
	var spawn_pos = $"Projectile Spawn Spot".global_position
	var target_pos = link.global_position
	
	var direction = (target_pos - spawn_pos).normalized()
	var base_angle = (rad_to_deg(atan2(direction.y, direction.x)) + 90 + 
		randi_range(random_innacuracy_range_degrees.x, random_innacuracy_range_degrees.y))
	
	for offset in fireball_directions:
		var fireball = fireball_scene.instantiate()
		get_parent().add_child(fireball)
		fireball.global_position = spawn_pos
		fireball.set_forward_vector(Utils.degrees_to_vector(base_angle + offset))

	current_shoot_timer = randf_range(random_shoot_timer.x, random_shoot_timer.y)
	is_shooting = false

func play_roar_sound() -> void:
	while true:
		get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.AQUAMENTUS_ROAR)
		await get_tree().create_timer(roar_sound_delay).timeout
