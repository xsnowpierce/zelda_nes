extends Area2D

var link : Node2D
var link_is_colliding : bool
@export var distance_required : float
@export var item_type : ENUM.KEY_ITEM_TYPE
signal item_picked_up

func _ready() -> void:
	link = get_tree().get_first_node_in_group("Player")
	$AnimatedSprite2D.frame = get_animation_frame_from_item_type(item_type)

func _on_area_entered(area: Area2D) -> void:
	link_is_colliding = true

func _on_area_exited(area: Area2D) -> void:
	link_is_colliding = false

func _process(delta: float) -> void:
	if(link_is_colliding):
		var distance = global_position.distance_to(link.global_position)
		if(distance <= distance_required):
			link.picked_up_key_item(item_type)
			item_picked_up.emit()
			get_tree().get_first_node_in_group("GameData").add_player_flag(get_obtain_player_flag_from_item_type(item_type))
			queue_free()

func get_animation_frame_from_item_type(item_type : ENUM.KEY_ITEM_TYPE) -> int:
	match item_type:
		ENUM.KEY_ITEM_TYPE.WOODEN_BOOMERANG:
			return 1
		ENUM.KEY_ITEM_TYPE.MAGICAL_BOOMERANG:
			return 2
		ENUM.KEY_ITEM_TYPE.BOMB:
			return 3
		ENUM.KEY_ITEM_TYPE.WOODEN_ARROW:
			return 4
		ENUM.KEY_ITEM_TYPE.SILVER_ARROW:
			return 5
		ENUM.KEY_ITEM_TYPE.BLUE_CANDLE:
			return 6
		ENUM.KEY_ITEM_TYPE.RED_CANDLE:
			return 7
		ENUM.KEY_ITEM_TYPE.RECORDER:
			return 8
		ENUM.KEY_ITEM_TYPE.FOOD:
			return 9
		ENUM.KEY_ITEM_TYPE.BLUE_POTION:
			return 11
		ENUM.KEY_ITEM_TYPE.RED_POTION:
			return 12
		ENUM.KEY_ITEM_TYPE.MAGICAL_ROD:
			return 13
		ENUM.KEY_ITEM_TYPE.WOODEN_SWORD:
			return 14
		ENUM.KEY_ITEM_TYPE.WHITE_SWORD:
			return 15
		ENUM.KEY_ITEM_TYPE.DOOR_KEY:
			return 16
		ENUM.KEY_ITEM_TYPE.MAGICAL_SHIELD:
			return 17
		ENUM.KEY_ITEM_TYPE.BOW:
			return 18
	return 0

func get_obtain_player_flag_from_item_type(item_type : ENUM.KEY_ITEM_TYPE) -> String:
	match item_type:
		ENUM.KEY_ITEM_TYPE.WOODEN_BOOMERANG:
			return "obtained_wooden_boomerang"
		ENUM.KEY_ITEM_TYPE.MAGICAL_BOOMERANG:
			return "obtained_magical_boomerang"
		ENUM.KEY_ITEM_TYPE.BOMB:
			return "obtained_bomb"
		ENUM.KEY_ITEM_TYPE.WOODEN_ARROW:
			return "obtained_wooden_arrows"
		ENUM.KEY_ITEM_TYPE.SILVER_ARROW:
			return "obtained_silver_arrows"
		ENUM.KEY_ITEM_TYPE.BLUE_CANDLE:
			return "obtained_blue_candle"
		ENUM.KEY_ITEM_TYPE.RED_CANDLE:
			return "obtained_red_candle"
		ENUM.KEY_ITEM_TYPE.RECORDER:
			return "obtained_whistle"
		ENUM.KEY_ITEM_TYPE.FOOD:
			return "obtained_food"
		ENUM.KEY_ITEM_TYPE.BLUE_POTION:
			return "obtained_blue_potion"
		ENUM.KEY_ITEM_TYPE.RED_POTION:
			return "obtained_red_potion"
		ENUM.KEY_ITEM_TYPE.MAGICAL_ROD:
			return "obtained_magical_rod"
		ENUM.KEY_ITEM_TYPE.WOODEN_SWORD:
			return "obtained_wooden_sword"
		ENUM.KEY_ITEM_TYPE.WHITE_SWORD:
			return "obtained_white_sword"
		ENUM.KEY_ITEM_TYPE.DOOR_KEY:
			return "obtained_door_key"
		ENUM.KEY_ITEM_TYPE.WOODEN_SHIELD:
			return "obtained_wooden_shield"
		ENUM.KEY_ITEM_TYPE.MAGICAL_SHIELD:
			return "obtained_magical_shield"
		ENUM.KEY_ITEM_TYPE.BOW:
			return "obtained_bow"
	return "null"
