class_name Projectile
extends Area2D


@export_category("Properties")
@export var speed := 200.0

var _wrapping := true

@onready var screen_size: Vector2


func _ready() -> void:
	screen_size = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed * delta
	if _wrapping:
		position.x = wrapf(position.x, 0, screen_size.x)
		position.y = wrapf(position.y, 0, screen_size.y)


func start(start_position: Vector2, start_rotation: float, should_wrap := true) -> void:
	global_position = start_position
	rotation = start_rotation
	_wrapping = should_wrap
	

func take_damage() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.take_damage()
	take_damage()


func _on_area_entered(area: Area2D) -> void:
	area.take_damage()
	take_damage()


func _on_destroy_timer_timeout() -> void:
	take_damage()
