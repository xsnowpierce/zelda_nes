extends Area2D

var collider_count : int

func _on_body_entered(_body: Node2D) -> void:
	collider_count += 1


func _on_body_exited(_body: Node2D) -> void:
	collider_count -= 1
