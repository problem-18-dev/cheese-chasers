class_name PowerUp
extends Area2D


signal picked_up(type: String)

@export var type: String


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	picked_up.emit(type)
	queue_free()
