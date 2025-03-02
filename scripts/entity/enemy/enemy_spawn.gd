extends Resource

class_name EnemySpawn

@export var enemy_type : ENUM.ENEMY_TYPE
enum USE_SPAWN_TYPE {GLOBAL_POSITION, RELATIVE_GRID}
@export var global_spawn_position : Vector2
##A position in grid boxes relative to the screen its being spawned into.
##[br]0,0 would be the center of the screen selected.
@export var relative_grid_position : Vector2
@export var use_spawn_type : USE_SPAWN_TYPE
var has_been_killed : bool
@export_group("Zora Settings")
@export var zora_movable_tile_range : Array[Vector4]
@export_group("Stalfos Settings")
@export var spawn_with_key : bool
@export_group("Blade Trap Settings")
@export var blade_trap_settings : BladeTrapSettings
