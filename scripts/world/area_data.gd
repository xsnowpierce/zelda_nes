extends Node2D

class_name area_data

var is_loaded : bool
@export var area_music : AudioStreamWAV

func _ready() -> void:
	is_loaded = true

func get_area_type() -> String:
	return "area_data"
