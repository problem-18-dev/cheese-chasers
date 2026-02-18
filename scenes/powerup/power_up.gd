class_name PowerUp
extends Area2D


signal picked_up(type: String, duration: float)

@export_category("Values")
@export var type: String
@export var duration := 5.0


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	picked_up.emit(type, duration)
	queue_free()
