extends EnemyAI_Wander

var is_active : bool = false
@export var active_wait_time : float

func _ready() -> void:
	await get_tree().create_timer(active_wait_time).timeout
	super()
	set_active()

func set_active() -> void:
	is_active = true
	$AnimatedSprite2D.play("down")

func _process(delta: float) -> void:
	if(!is_active):
		return
	super(delta)

func _on_area_entered(area: Area2D) -> void:
	if(!is_active):
		return
	super(area)

func attacked(damage : int, from : Vector2) -> void:
	if(!is_active):
		return
	super(damage, from)
