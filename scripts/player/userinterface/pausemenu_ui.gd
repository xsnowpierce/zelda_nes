extends Node

var has_control : bool
var current_selected_index : int
var has_bow
@onready var usable_items_menu : Control = $"top half/usable_items_row"

signal selected_item_index_change(new_index : int)
signal selected_item_type_change(new_item : ENUM.ITEM_TYPE)
signal item_selection_change_sound()

func _ready() -> void:
	has_bow = get_tree().get_first_node_in_group("GameData").has_player_flag("obtained_bow")
	selected_item_index_change.emit(current_selected_index)

func _process(delta: float) -> void:
	if(!has_control):
		return
	if(Input.is_action_just_pressed("move_right")):
		var next_item_in_direction = get_next_item_slot_in_direction(1)
		if(next_item_in_direction != -1):
			current_selected_index = next_item_in_direction
		selected_item_index_change.emit(current_selected_index)
		selected_item_type_change.emit(get_item_slot(next_item_in_direction))
		item_selection_change_sound.emit()
	if(Input.is_action_just_pressed("move_left")):
		var next_item_in_direction = get_next_item_slot_in_direction(-1)
		if(next_item_in_direction != -1):
			current_selected_index = next_item_in_direction
		selected_item_index_change.emit(current_selected_index)
		selected_item_type_change.emit(get_item_slot(next_item_in_direction))
		item_selection_change_sound.emit()
	
func get_next_item_slot_in_direction(direction: int) -> int:
	if usable_items_menu.item_slots.is_empty():
		return -1

	var valid_items := []
	var selected_index := -1
	var skip_slot := 2 if not has_bow else -1

	# Collect valid items and track selected index
	for i in range(usable_items_menu.item_slots.size()):
		if get_item_slot(i) != ENUM.ITEM_TYPE.NULL and i != skip_slot:
			valid_items.append(i)
			if i == current_selected_index:
				selected_index = len(valid_items) - 1

	if valid_items.is_empty():
		return -1

	# Handle movement based on direction
	if selected_index == -1:
		return valid_items[0] if direction == 1 else valid_items[-1]

	var next_index = selected_index + direction

	# Wrap around if needed
	if next_index < 0:
		return valid_items[-1]  # Select last item
	elif next_index >= len(valid_items):
		return valid_items[0]  # Select first item

	return valid_items[next_index]

func get_item_slot(index: int) -> ENUM.ITEM_TYPE:
	if index >= 0 and index < usable_items_menu.item_slots.size():
		return usable_items_menu.item_slots[index]  # Directly return if it's already an ENUM
	return ENUM.ITEM_TYPE.NULL  # Return NULL if out of bounds


func is_item_slot_null(item_slot : int) -> bool:
	var current_item : ENUM.ITEM_TYPE = usable_items_menu.item_slots[item_slot]
	print("item at slot: ", item_slot, " is ", current_item)
	if(current_item == ENUM.ITEM_TYPE.NULL):
			return true
	# found our item
	return false

func open_pause_menu() -> void:
	has_bow = get_tree().get_first_node_in_group("GameData").has_player_flag("obtained_bow")

func close_pause_menu() -> void:
	pass

func _on_game_pause_menu_opened() -> void:
	open_pause_menu()

func _on_game_pause_menu_closed() -> void:
	close_pause_menu()


func _on_game_pause_menu_control(given_control: bool) -> void:
	has_control = given_control
