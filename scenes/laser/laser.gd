extends Projectile


func _on_destroy_timer_timeout() -> void:
	queue_free()
