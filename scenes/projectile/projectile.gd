class_name Projectile
extends Area2D


@export_category("Properties")
@export var speed := 200.0

@onready var screen_size: Vector2


func _ready() -> void:
	screen_size = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed * delta
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)


func start(start_position: Vector2, start_rotation: float) -> void:
	global_position = start_position
	rotation = start_rotation


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mice"):
		body.take_damage()
	
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
