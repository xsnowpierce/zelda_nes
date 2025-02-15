extends Area2D

var link : Node2D
var link_is_colliding : bool
@export var distance_required : float
@export var item_type : ENUM.KEY_ITEM_TYPE

func _ready() -> void:
	link = get_tree().get_first_node_in_group("Player")

func _on_area_entered(area: Area2D) -> void:
	link_is_colliding = true

func _on_area_exited(area: Area2D) -> void:
	link_is_colliding = false

func _process(delta: float) -> void:
	if(link_is_colliding):
		var distance = global_position.distance_to(link.global_position)
		if(distance <= distance_required):
			link.picked_up_key_item(item_type)
			get_parent().sword_obtained()
			queue_free()
