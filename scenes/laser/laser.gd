extends Projectile


func _on_destroy_timer_timeout() -> void:
	print("time out!", $DestroyTimer.wait_time)
	queue_free()
