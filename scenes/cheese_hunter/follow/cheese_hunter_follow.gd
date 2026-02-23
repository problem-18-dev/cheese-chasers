extends PathFollow2D


@export_category("Speed")
@export var speed := 0.05


func _process(_delta: float) -> void:
	if is_equal_approx(progress_ratio, 1.0):
		queue_free()


func _physics_process(delta: float) -> void:
	progress_ratio += speed * delta


func _on_cheese_hunter_hit() -> void:
	queue_free()
