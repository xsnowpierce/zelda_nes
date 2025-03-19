extends Node

@export_group("Enemy Groups")
@export var enemy_group_A : Array[ENUM.ENEMY_TYPE] = [
	ENUM.ENEMY_TYPE.OCTOROK,
	ENUM.ENEMY_TYPE.TEKTITE,
	ENUM.ENEMY_TYPE.MOBLIN,
	ENUM.ENEMY_TYPE.BLUE_LEEVER,
	ENUM.ENEMY_TYPE.BLUE_WIZZROBE
]
@export var enemy_group_B : Array[ENUM.ENEMY_TYPE] = [
	ENUM.ENEMY_TYPE.BLUE_OCTOROK,
	ENUM.ENEMY_TYPE.BLUE_MOBLIN,
	ENUM.ENEMY_TYPE.BLUE_LYNEL,
	ENUM.ENEMY_TYPE.GORIYA,
	ENUM.ENEMY_TYPE.GIBDO,
	ENUM.ENEMY_TYPE.VIRE,
	ENUM.ENEMY_TYPE.DARKNUT,
	ENUM.ENEMY_TYPE.WIZZROBE
]
@export var enemy_group_C : Array[ENUM.ENEMY_TYPE] = [
	ENUM.ENEMY_TYPE.BLUE_TEKTITE,
	ENUM.ENEMY_TYPE.LEEVER,
	ENUM.ENEMY_TYPE.STALFOS,
	ENUM.ENEMY_TYPE.GEL,
	ENUM.ENEMY_TYPE.GHINI,
	ENUM.ENEMY_TYPE.ROPE,
	ENUM.ENEMY_TYPE.FLASHING_ROPE,
	ENUM.ENEMY_TYPE.WALLMASTER,
	ENUM.ENEMY_TYPE.POLS_VOICE,
	ENUM.ENEMY_TYPE.BLUE_LANMOLA
]
@export var enemy_group_D : Array[ENUM.ENEMY_TYPE] = [
	ENUM.ENEMY_TYPE.PEAHAT,
	ENUM.ENEMY_TYPE.ZORA,
	ENUM.ENEMY_TYPE.LYNEL,
	ENUM.ENEMY_TYPE.BLUE_GORIYA,
	ENUM.ENEMY_TYPE.BLUE_DARKNUT,
	ENUM.ENEMY_TYPE.MOLDORM,
	ENUM.ENEMY_TYPE.GLEEOK,
	ENUM.ENEMY_TYPE.MANHANDLA,
	ENUM.ENEMY_TYPE.AQUAMENTUS,
	ENUM.ENEMY_TYPE.DODONGO,
	ENUM.ENEMY_TYPE.GOHMA,
	ENUM.ENEMY_TYPE.MINI_DIGDOGGER,
	ENUM.ENEMY_TYPE.PATRA,
	ENUM.ENEMY_TYPE.LANMOLA
]

@export_group("Enemy Group Drops")
@export var group_A_drops : Array[ENUM.ITEM_TYPE] = [
	ENUM.ITEM_TYPE.GREEN_RUPEE, 
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.FAIRY,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.HEART
]
@export var group_B_drops : Array[ENUM.ITEM_TYPE] = [
	ENUM.ITEM_TYPE.BOMB, 
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.TIMER,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.BOMB,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.BOMB,
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.HEART
]
@export var group_C_drops : Array[ENUM.ITEM_TYPE] = [
	ENUM.ITEM_TYPE.GREEN_RUPEE, 
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.BLUE_RUPEE,
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.TIMER,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.BLUE_RUPEE
]
@export var group_D_drops : Array[ENUM.ITEM_TYPE] = [
	ENUM.ITEM_TYPE.HEART, 
	ENUM.ITEM_TYPE.FAIRY,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.FAIRY,
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.HEART,
	ENUM.ITEM_TYPE.GREEN_RUPEE,
	ENUM.ITEM_TYPE.HEART
]

@export_group("Group Drop Rates")
@export var group_A_drop_chance : float = 0.31
@export var group_B_drop_chance : float = 0.41
@export var group_C_drop_chance : float = 0.59
@export var group_D_drop_chance : float = 0.41

var guaranteed_rupee_counter : int
var kill_counter : int
var current_drop_turn : int
var last_kill_group : int
var last_kill_method : ENUM.KILL_METHOD

func add_kill(type : ENUM.ENEMY_TYPE, kill_method : ENUM.KILL_METHOD) -> void:
	
	last_kill_method = kill_method
	
	if(guaranteed_rupee_counter < 10):
		guaranteed_rupee_counter += 1
	kill_counter += 1
		
	if(is_in_group_x(type)):
		return
		
	current_drop_turn += 1
	if(current_drop_turn >= 10):
		current_drop_turn = 0
		
	if(enemy_group_A.has(type)):
		last_kill_group = 0
	elif(enemy_group_B.has(type)):
		last_kill_group = 1
	elif(enemy_group_C.has(type)):
		last_kill_group = 2
	elif(enemy_group_D.has(type)):
		last_kill_group = 3
	else:
		last_kill_group = 4
	print("enemy kill added: GRC = ", guaranteed_rupee_counter, ", KC = ", kill_counter, 
	", CDT = ", current_drop_turn, ", LKG = ", last_kill_group, ", LKM = ", last_kill_method)
			
func get_next_drop() -> ENUM.ITEM_TYPE:
	
	return ENUM.ITEM_TYPE.BOMB
	
	if(last_kill_group == 4):
		return ENUM.ITEM_TYPE.NULL
	
	# do guaranteed drops here
	if(kill_counter % 10 == 1 && last_kill_method == ENUM.KILL_METHOD.BOMB):
		return ENUM.ITEM_TYPE.BOMB
	if(kill_counter == 16):
		# guaranteed drop fairy
		kill_counter = 0
		guaranteed_rupee_counter = 0
	if(guaranteed_rupee_counter == 10):
		# guaranteed drop rupee
		guaranteed_rupee_counter = 0
	
	var drop_table : Array[ENUM.ITEM_TYPE]
	var drop_chance : float
	
	match last_kill_group:
		0:
			drop_table = group_A_drops
			drop_chance = group_A_drop_chance
		1:
			drop_table = group_B_drops
			drop_chance = group_B_drop_chance
		2:
			drop_table = group_C_drops
			drop_chance = group_C_drop_chance
		3:
			drop_table = group_D_drops
			drop_chance = group_D_drop_chance
	
	# roll the item
	if(drop_chance <= randf_range(0, 1)):
		# drop the item
		return drop_table[current_drop_turn]
	else:
		# failed rng
		return ENUM.ITEM_TYPE.NULL
	

func link_was_hit() -> void:
	guaranteed_rupee_counter = 0
	kill_counter = 0

func is_in_group_x(type : ENUM.ENEMY_TYPE) -> bool:
	if(enemy_group_A.has(type)):
		return false
	elif(enemy_group_B.has(type)):
		return false
	elif(enemy_group_C.has(type)):
		return false
	elif(enemy_group_D.has(type)):
		return false
	return true
