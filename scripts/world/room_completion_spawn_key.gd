extends DungeonTileListener

@export var spawn_key_location : Vector2
@export var drop_at_last_enemy_killed : bool
var dropped_item_scene : PackedScene = load("res://scenes/dropped_item.tscn")
var room_completed : bool
var key_picked_up : bool
var key_spawn_location : Vector2
var key_object : Node2D

func start() -> void:
	if(room_completed and !key_picked_up):
		spawn_key(key_spawn_location)

func exit() -> void:
	if(is_instance_valid(key_object)):
		key_object.queue_free()

func room_completion(last_kill_location : Vector2) -> void:
	room_completed = true
	if(drop_at_last_enemy_killed):
		key_spawn_location = last_kill_location
	else:
		key_spawn_location = spawn_key_location
	spawn_key(key_spawn_location)

func spawn_key(location : Vector2) -> void:
	key_object = dropped_item_scene.instantiate()
	add_child(key_object)
	key_object.global_position = location
	key_object.set_item_type(ENUM.ITEM_TYPE.KEY)
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.KEY_APPEARANCE)
	key_object.connect("item_picked_up", Callable(self, "key_was_picked_up"))

func key_was_picked_up() -> void:
	key_picked_up = true
