class_name Floater
extends RigidBody2D


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	_wrap_position()


func _wrap_position() -> void:
	var screen_size := get_viewport_rect().size
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
