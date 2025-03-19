extends Node

@export var NPC_SPRITE_DATABASE : Array[Texture]
@export var dropped_item_scene : PackedScene = preload("res://scenes/dropped_item.tscn")

@export var room_link_spawn_position : Vector2
@export var text_print_delay : float = 0.12
@export var npc_disappear_time : float = 1

var camera : Camera2D
var link : Node2D
var game_data : Node
var player_has_input : bool
var current_interior_data : InteriorData
var item_objects : Array[Node2D]

func initialize(camera_object : Camera2D, link_object : Node2D, game_data_object : Node) -> void:
	link = link_object
	camera = camera_object
	game_data = game_data_object

func reset_interior() -> void:
	$dialogue_text.text = ""
	$dialogue_text2.text = ""
	$dialogue_text.visible_characters = 0
	$dialogue_text2.visible_characters = 0
	$fire.play("appear")
	$fire.pause()
	$fire2.play("appear")
	$fire.pause()
	$npc.visible = false
	$room_centre.visible = false
	$take_any_rupee.visible = false
	for item in item_objects:
		if(is_instance_valid(item)):
			item.queue_free()
	item_objects.clear()

func handle_interior(data : InteriorData) -> void:
	current_interior_data = data
	reset_interior()
	# store initial positions to return to later
	var link_enter_door_position : Vector2 = link.global_position
	var camera_coordinate_before_entering : Vector2 = camera.global_position
	
	$"LEAVE AREA".link_moveto_position = link_enter_door_position
	$"LEAVE AREA".camera_moveto_position = Utils.get_tile_coordinate_from_global_coordinate(camera.global_position)
	
	# handle link entering door
	camera.set_camera_tile(Vector2(-2, 2))
	link.position = room_link_spawn_position
	player_has_input = false
	
	if(data.room_music != null):
		$MusicPlayer.stream = data.room_music
		$MusicPlayer.play(0.0)
	
	# load all the data from InteriorData
	$fire.play("appear")
	$fire2.play("appear")
	
	if(!game_data.has_player_flag(data.flag_add_after_completion)):
		
		$dialogue_text.text = data.dialogue_line_one
		$dialogue_text2.text = data.dialogue_line_two
		if(data.npc_sprite_index >= 0):
			$npc.visible = true
			$npc.sprite_frames.set_frame("default", 3, NPC_SPRITE_DATABASE[data.npc_sprite_index])
			$npc.sprite_frames.set_frame("disappear", 0, NPC_SPRITE_DATABASE[data.npc_sprite_index])
			$npc.play("default")
		else:
			$npc.visible = false
	
	# do room appear animation
	await $fire.animation_finished
	$fire.play("fire")
	$fire2.play("fire")
	
	if(!game_data.has_player_flag(data.flag_add_after_completion)):
		match data.interior_type:
			data.INTERIOR_TYPE.ITEM_GIVEN:
				# spawn item(s)
				if(data.item_to_give != ENUM.ITEM_TYPE.NULL):
					var item_object := dropped_item_scene.instantiate()
					item_object.item_type = data.item_to_give
					add_child(item_object)
					item_object.global_position = $room_centre.global_position - Vector2(8, 8)
					item_object.connect("item_picked_up", Callable(self, "key_item_picked_up"))
					item_objects.append(item_object)
			data.INTERIOR_TYPE.SHOP:
				load_shop_items()
			data.INTERIOR_TYPE.TAKE_ANY:
				load_take_any_you_want_items()
			data.INTERIOR_TYPE.ITS_A_SECRET:
				$take_any_rupee.visible = true
				$take_any_rupee/amount_text.text = ""
				if(data.rupee_amount > 0):
					var item_object := dropped_item_scene.instantiate()
					item_object.set_item_type(ENUM.ITEM_TYPE.GREEN_RUPEE)
					item_object.rupee_value_override = data.rupee_amount
					add_child(item_object)
					item_object.global_position = $room_centre.global_position
					item_object.connect("item_picked_up", Callable(self, "key_item_picked_up"))
					item_objects.append(item_object)
	
	# print text if any
	if(data.flag_add_after_completion.is_empty() or !game_data.has_player_flag(data.flag_add_after_completion)):
		if(!data.dialogue_line_one.is_empty() or !data.dialogue_line_two.is_empty()):
			await typing_animation()
	
	player_has_input = true

func load_shop_items() -> void:
	if(current_interior_data.shop_item_1 != null):
		var item := current_interior_data.shop_item_1 
		$room_centre/purchase_text_price_1.text = str(item.item_price)
		var item_object := dropped_item_scene.instantiate()
		item_object.item_type = item.item_type
		add_child(item_object)
		item_object.global_position = $room_centre.global_position + Vector2(-40, -8)
		item_object.connect("item_picked_up", Callable(self, "key_item_picked_up"))
		item_objects.append(item_object)
	if(current_interior_data.shop_item_2 != null):
		var item := current_interior_data.shop_item_2 
		$room_centre/purchase_text_price_2.text = str(item.item_price)
		var item_object := dropped_item_scene.instantiate()
		item_object.item_type = item.item_type
		add_child(item_object)
		item_object.global_position = $room_centre.global_position + Vector2(-8, -8)
		item_object.connect("item_picked_up", Callable(self, "key_item_picked_up"))
		item_objects.append(item_object)
	if(current_interior_data.shop_item_3 != null):
		var item := current_interior_data.shop_item_3 
		$room_centre/purchase_text_price_3.text = str(item.item_price)
		var item_object := dropped_item_scene.instantiate()
		item_object.item_type = item.item_type
		add_child(item_object)
		item_object.global_position = $room_centre.global_position + Vector2(24, -8)
		item_object.connect("item_picked_up", Callable(self, "key_item_picked_up"))
		item_objects.append(item_object)
	$room_centre.visible = true
	pass

func load_take_any_you_want_items() -> void:
	var item_amount : int = 0
	if(current_interior_data.take_any_item_choice_1 != ENUM.ITEM_TYPE.NULL):
		item_amount += 1
	if(current_interior_data.take_any_item_choice_2 != ENUM.ITEM_TYPE.NULL):
		item_amount += 1
	if(current_interior_data.take_any_item_choice_3 != ENUM.ITEM_TYPE.NULL):
		item_amount += 1
	
	if(current_interior_data.take_any_item_choice_1 != ENUM.ITEM_TYPE.NULL):
		var item := current_interior_data.take_any_item_choice_1
		var item_object := dropped_item_scene.instantiate()
		item_object.item_type = item
		add_child(item_object)
		match item_amount:
			1:
				item_object.global_position = $room_centre.global_position + Vector2(-8, -8)
			2:
				item_object.global_position = $room_centre.global_position + Vector2(-40, -8)
			3:
				item_object.global_position = $room_centre.global_position + Vector2(-40, -8)
		item_object.connect("item_picked_up", Callable(self, "key_item_picked_up"))
		item_objects.append(item_object)
		
	if(current_interior_data.take_any_item_choice_2 != ENUM.ITEM_TYPE.NULL):
		var item := current_interior_data.take_any_item_choice_2
		var item_object := dropped_item_scene.instantiate()
		item_object.item_type = item
		add_child(item_object)
		match item_amount:
			1:
				item_object.global_position = $room_centre.global_position + Vector2(-8, -8)
			2:
				item_object.global_position = $room_centre.global_position + Vector2(24, -8)
			3:
				item_object.global_position = $room_centre.global_position + Vector2(-8, -8)
		item_object.connect("item_picked_up", Callable(self, "key_item_picked_up"))
		item_objects.append(item_object)
	if(current_interior_data.take_any_item_choice_3 != ENUM.ITEM_TYPE.NULL):
		var item := current_interior_data.take_any_item_choice_3
		var item_object := dropped_item_scene.instantiate()
		item_object.item_type = item
		add_child(item_object)
		match item_amount:
			1:
				item_object.global_position = $room_centre.global_position + Vector2(-8, -8)
			2:
				item_object.global_position = $room_centre.global_position + Vector2(32, -8)
			3:
				item_object.global_position = $room_centre.global_position + Vector2(32, -8)
		item_object.connect("item_picked_up", Callable(self, "key_item_picked_up"))
		item_objects.append(item_object)

func typing_animation() -> void:
	$dialogue_text.visible = true
	$dialogue_text2.visible = true
	$dialogue_text.visible_characters = 0
	$dialogue_text2.visible_characters = 0
	var dialogue_max_chars = $dialogue_text.get_total_character_count()
	$text_progress_sound.play()
	for character in dialogue_max_chars:
		$dialogue_text.visible_characters += 1
		await get_tree().create_timer(text_print_delay).timeout
	dialogue_max_chars = $dialogue_text2.get_total_character_count()
	for character in dialogue_max_chars:
		$dialogue_text2.visible_characters += 1
		await get_tree().create_timer(text_print_delay).timeout
	$text_progress_sound.stop()

func room_completion_achieved() -> void:
	match current_interior_data.interior_type:
		current_interior_data.INTERIOR_TYPE.ITS_A_SECRET:
			$take_any_rupee/amount_text.text = str(current_interior_data.rupee_amount)
			$take_any_rupee/amount_text.visible = true
		_:
			player_has_input = false
			$dialogue_text.visible = false
			$dialogue_text2.visible = false
	
			if($npc.visible):
				$npc.play("disappear")
				await get_tree().create_timer(npc_disappear_time).timeout
				$npc.visible = false
	
			if(current_interior_data.interior_type == current_interior_data.INTERIOR_TYPE.SHOP):
				$room_centre.visible = false
				for item in item_objects:
					if(is_instance_valid(item)):
						item.queue_free()
				item_objects.clear()
	
	if(!current_interior_data.flag_add_after_completion.is_empty()):
		game_data.add_player_flag(current_interior_data.flag_add_after_completion)
	
	player_has_input = true

func key_item_picked_up() -> void:
	room_completion_achieved()
