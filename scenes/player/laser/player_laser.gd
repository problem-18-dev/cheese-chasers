extends Projectile


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("friendly_projectiles"):
		return

	super(area)
