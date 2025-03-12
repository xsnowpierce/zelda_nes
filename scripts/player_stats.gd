extends Resource

class_name PlayerStats

@export var player_flags : Array[String]

@export_subgroup("Health")
@export var max_player_health : int = 6
@export var current_player_health : int = 6
@export_subgroup("Rupees")
@export var max_rupees : int = 255
@export var current_rupees : int = 0
@export_subgroup("Keys")
@export var max_keys : int = 255
@export var current_keys : int = 0
@export_subgroup("Bombs")
@export var max_bombs : int = 8
@export var current_bombs : int = 0

@export_subgroup("Key Items")
@export var has_wooden_sword : bool
@export var has_white_sword : bool
@export var has_magical_sword : bool
@export var has_wooden_shield : bool
@export var has_magical_shield : bool
@export var has_wooden_boomerang : bool
@export var has_magical_boomerang : bool
@export var has_bomb : bool
@export var has_bow : bool
@export var has_wooden_arrow : bool
@export var has_silver_arrow : bool
@export var has_blue_candle : bool
@export var has_red_candle : bool
@export var has_recorder : bool
@export var has_food : bool
@export var has_letter : bool
@export var has_red_potion : bool
@export var has_blue_potion : bool
@export var has_magical_rod : bool

@export_subgroup("Dungeon Key Items")
@export var has_eagle_compass : bool
@export var has_eagle_map : bool

@export var current_equipped_item_a : ENUM.ITEM_TYPE = ENUM.ITEM_TYPE.NULL
@export var current_equipped_item_b : ENUM.ITEM_TYPE = ENUM.ITEM_TYPE.NULL
