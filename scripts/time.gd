extends Node

var delta_time : float
var time_scale : float = 1

func _process(delta: float) -> void:
	delta_time = delta * time_scale
