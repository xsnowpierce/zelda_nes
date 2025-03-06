extends Resource

class_name InteriorData

enum INTERIOR_TYPE {
	ITEM_GIVEN, ## Like the wooden sword room. An item will spawn in the centre of the room and will wait for link to pick it up before room completion.
	SHOP, ## The player will be given multiple item choices with a price, and once the player stands on one of them, they will obtain the item and lose a certain amount of rupees for cost, before room completion.
	TAKE_ANY, ## The player will be given multiple items to choose from, and once chosen, the player will be unable to pick the other(s).
	ITS_A_SECRET, ## Similar to ITEM_GIVEN, except the item can only be rupees, and instead of the item deleting after pickup, text appears showing the amount obtianed.
	EMPTY ## The room will be empty, just with two fires.
}

## The type of room it is.
@export var interior_type : INTERIOR_TYPE
## The flag to add to the player after the room has reached it's intended goal 
## (player picked up given item, player bought an item, etc.) [br] [br]
## [b] Leave blank if the room shouldn't change after completion. [/b]
@export var flag_add_after_completion : String
## The top line of the dialogue to print when the player enters the room. [br]
## [br] If left blank, this will be skipped.
@export var dialogue_line_one : String
## The bottom line of the dialogue to print when the player enters the room. [br]
## [br] If left blank, this will be skipped.
@export var dialogue_line_two : String

## Sets the NPC from the INTERIOR_HANDLER texture array. Leave at -1 if there is no sprite to load.
@export var npc_sprite_index : int = -1

## The music to play when the player enters the room. [br] [br]
## If left blank, no music will be playing.
@export var room_music : AudioStreamWAV

@export_group("Item Given Settings")
@export var item_to_give : ENUM.ITEM_TYPE

@export_group("Shop Settings")
## The item for purchase on the left side [br]
## Leave blank to have no item.
@export var shop_item_1 : ShopItem
## The item for purchase in the middle [br]
## Leave blank to have no item.
@export var shop_item_2 : ShopItem
## The item for purchase on the right [br]
## Leave blank to have no item.
@export var shop_item_3 : ShopItem

@export_group("Take Any One Settings")
@export var take_any_item_choice_1 : ENUM.ITEM_TYPE
@export var take_any_item_choice_2 : ENUM.ITEM_TYPE
@export var take_any_item_choice_3 : ENUM.ITEM_TYPE

@export_group("It's A Secret Settings")
@export var rupee_amount : int
