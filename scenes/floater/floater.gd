class_name Floater
extends RigidBody2D


var _screen_size: Vector2


func _ready() -> void:
	_screen_size = get_viewport_rect().size


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	position.x = wrapf(position.x, 0, _screen_size.x)
	position.y = wrapf(position.y, 0, _screen_size.y)
