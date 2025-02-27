extends InteractableBlock

@export var disappear_timer : float = 1 
var armos_scene : PackedScene = load("res://scenes/enemy_scenes/armos.tscn")
var spawned_armos
var has_spawned : bool

func block_interact(interacted_from_direction : Vector2) -> void:
	if(has_spawned):
		return
		
	has_spawned = true
	spawned_armos = armos_scene.instantiate()
	get_parent().call_deferred("add_child", spawned_armos)
	spawned_armos.global_position = global_position
	spawned_armos.connect("has_died", Callable(self, "spawned_enemy_has_died"))
	await get_tree().create_timer(disappear_timer).timeout
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Area2D/CollisionShape2D.call_deferred("set_disabled", true)
	$Sprite2D.visible = false

func awake():
	super()
	$CollisionShape2D.set_disabled(false)
	$Area2D/CollisionShape2D.set_disabled(false)
	$Sprite2D.visible = true
	
func sleep():
	super()
	has_spawned = false
	if(is_instance_valid(spawned_armos)):
		spawned_armos.queue_free()

func spawned_enemy_has_died() -> void:
	queue_free()
