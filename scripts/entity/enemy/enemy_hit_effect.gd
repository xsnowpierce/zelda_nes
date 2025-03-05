extends AnimatedSprite2D

# hit flash
var hit_effect_length : float = 0.8
var hit_effect_colour_change_time : float = 0.1
var is_hit_flash : bool
var hit_flash_timer : float

@export var hit_effect_palette_1 : SpriteHitColour = load("res://colour palettes/hit_effect_1.tres")
@export var hit_effect_palette_2 : SpriteHitColour = load("res://colour palettes/hit_effect_2.tres")
@export var hit_effect_palette_3 : SpriteHitColour = load("res://colour palettes/hit_effect_3.tres")
var starting_sprite_palette : SpriteHitColour

func _ready() -> void:
	starting_sprite_palette = SpriteHitColour.new()
	if(material.get("shader_parameter/OLD_COLOUR_1") != null):
		starting_sprite_palette.new_colour_01 = material.get("shader_parameter/OLD_COLOUR_1")
	if(material.get("shader_parameter/OLD_COLOUR_2") != null):
		starting_sprite_palette.new_colour_02 = material.get("shader_parameter/OLD_COLOUR_2")
	if(material.get("shader_parameter/OLD_COLOUR_3") != null):
		starting_sprite_palette.new_colour_03 = material.get("shader_parameter/OLD_COLOUR_3")
	if(material.get("shader_parameter/OLD_COLOUR_4") != null):
		starting_sprite_palette.new_colour_04 = material.get("shader_parameter/OLD_COLOUR_4")
	set_colour_palette(starting_sprite_palette)

func hit_effect() -> void:
	hit_flash_timer = hit_effect_length
	if(is_hit_flash):
		return
	is_hit_flash = true
	var hit_change_timer : float = hit_effect_colour_change_time
	var times_changed : int = 1
	while hit_flash_timer > 0:
		hit_flash_timer -= get_process_delta_time()
		hit_change_timer -= get_process_delta_time()
		if(hit_change_timer <= 0):
			hit_change_timer = hit_effect_colour_change_time
			if(times_changed >= 4):
				times_changed = 0
			match times_changed:
				1:
					set_colour_palette(hit_effect_palette_1)
				2:
					set_colour_palette(hit_effect_palette_2)
				3:
					set_colour_palette(hit_effect_palette_3)
				_:
					set_colour_palette(starting_sprite_palette)
			times_changed += 1
		await get_tree().process_frame
	set_colour_palette(starting_sprite_palette)
	is_hit_flash = false

func set_colour_palette(colour_set : SpriteHitColour) -> void:
	material.set("shader_parameter/NEW_COLOUR_1", Utils.colour_to_vec4(colour_set.new_colour_01))
	material.set("shader_parameter/NEW_COLOUR_2", Utils.colour_to_vec4(colour_set.new_colour_02))
	material.set("shader_parameter/NEW_COLOUR_3", Utils.colour_to_vec4(colour_set.new_colour_03))
	material.set("shader_parameter/NEW_COLOUR_4", Utils.colour_to_vec4(colour_set.new_colour_04))
