extends TextureRect

@export var empty_heart_texture : Texture
@export var half_heart_texture : Texture
@export var full_heart_texture : Texture

func set_heart_amount(amount : ENUM.HEART_AMOUNT):
	match amount:
		ENUM.HEART_AMOUNT.EMPTY:
			texture = empty_heart_texture
		ENUM.HEART_AMOUNT.HALF:
			texture = half_heart_texture
		ENUM.HEART_AMOUNT.FULL:
			texture = full_heart_texture
