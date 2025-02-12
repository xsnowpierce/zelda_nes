extends FlowContainer

@export var heart_scene : PackedScene = preload("res://scenes/ui_heart.tscn")

var heart_object_array : Array
var current_health : int
var current_max_health : int
	
func set_current_hearts(new_current_amount : int) -> void:
	destroy_current_hearts()
	current_health = new_current_amount
	generate_hearts()
	
func set_max_hearts(new_max_amount : int) -> void:
	destroy_current_hearts()
	current_max_health = new_max_amount
	generate_hearts()

func generate_hearts() -> void:
	var hearts_to_generate = ceili(current_max_health / 2.0)
	var health_ticked = current_health
	for number in hearts_to_generate:
		var new_heart = heart_scene.instantiate()
		add_child(new_heart)
		if(health_ticked >= 2):
			new_heart.set_heart_amount(ENUM.HEART_AMOUNT.FULL)
			health_ticked -= 2
		elif(health_ticked == 1):
			new_heart.set_heart_amount(ENUM.HEART_AMOUNT.HALF)
			health_ticked -= 1
		else:
			new_heart.set_heart_amount(ENUM.HEART_AMOUNT.EMPTY)
		heart_object_array.append(new_heart)
		

func destroy_current_hearts() -> void:
	if(heart_object_array.is_empty()):
		return
	for heart in heart_object_array:
		heart.queue_free()
	heart_object_array = []

func _on_game_player_max_health_changed(new_max_amount : int) -> void:
	set_max_hearts(new_max_amount)


func _on_game_player_health_changed(new_current_amount : int) -> void:
	set_current_hearts(new_current_amount)
