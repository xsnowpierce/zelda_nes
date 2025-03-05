extends EnemyAI_Wander_And_Shoot

class_name GoriyaAI

@export var boomerang_scene : PackedScene
var spawned_boomerang : Node2D
var boomerang_type : Boomerang.BOOMERANG_TYPE = Boomerang.BOOMERANG_TYPE.WOODEN

func _ready() -> void:
	projectile_scene = boomerang_scene
	super()

func can_move() -> bool:
	if is_instance_valid(spawned_boomerang):
		return false
	return super()

func spawn_projectile() -> void:
	if(is_instance_valid(spawned_boomerang)):
		spawned_boomerang.queue_free()
	spawned_boomerang = projectile_scene.instantiate()
	get_parent().add_child(spawned_boomerang)
	spawned_boomerang.global_position = position + (current_forward_vector * 16) + Vector2(8, 8)
	spawned_boomerang.initialize_boomerang(boomerang_type, current_forward_vector, get_tree().get_first_node_in_group("Camera"), self, true)
