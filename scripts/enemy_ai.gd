extends Area2D

@export var max_health : int = 1
@export var attacked_iframes : int = 16
var current_attacked_iframes : float
var current_health : int
@export_flags_2d_physics var collision_layers_bitmask

var death_scene : PackedScene = load("res://scenes/enemy_death.tscn")
var camera
signal was_attacked
signal has_died

func _ready() -> void:
	current_health = max_health
	camera = get_tree().get_first_node_in_group("Camera")
	
func _process(delta: float) -> void:
	current_attacked_iframes -= delta
	
func _on_area_entered(area: Area2D) -> void:
	print(area.get_groups())
	if(area.is_in_group("Player_Attack")):
		attacked()

func attacked() -> void:
	if(current_attacked_iframes > 0):
		return
	current_attacked_iframes = attacked_iframes / 60.0
	current_health -= 1
	was_attacked.emit()
	$AudioStreamPlayer.play()
	if(current_health <= 0):
		death()

func death() -> void:
	var death_object = death_scene.instantiate()
	get_parent().add_child(death_object)
	death_object.position = position
	has_died.emit()
	queue_free()
