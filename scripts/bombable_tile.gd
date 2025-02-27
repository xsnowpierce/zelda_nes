extends "res://scripts/entity.gd"

class_name BombableTile

var green_spritesheet : Texture2D = load("res://images/sheet_03.png")
var brown_spritesheet : Texture2D = load("res://images/tileset2.png")
var orange_spritesheet : Texture2D = load("res://images/sheet_2.png")
var white_spritesheet : Texture2D = load("res://images/sheet_04.png")
enum SPRITESHEET {GREEN, BROWN, ORANGE, WHITE}
@export var use_spritesheet : SPRITESHEET = SPRITESHEET.BROWN
signal was_bombed

func _ready() -> void:
	set_sprite_from_spritesheet()

func set_sprite_from_spritesheet() -> void:
	var usetex : AtlasTexture = AtlasTexture.new()
	match use_spritesheet:
		SPRITESHEET.GREEN:
			usetex.set_atlas(green_spritesheet)
		SPRITESHEET.BROWN:
			usetex.set_atlas(brown_spritesheet)
		SPRITESHEET.ORANGE:
			usetex.set_atlas(orange_spritesheet)
		SPRITESHEET.WHITE:
			usetex.set_atlas(white_spritesheet)
	usetex.region = Rect2(32, 16, 16, 16)
	$Sprite2D.texture = usetex

func _on_hitbox_area_entered(area: Area2D) -> void:
	was_bombed.emit()
	queue_free()
