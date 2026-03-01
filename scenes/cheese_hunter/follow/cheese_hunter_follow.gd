extends PathFollow2D


signal score_added(score: int)

@export_category("Speed")
@export var speed := 0.05
@export_category("Score")
@export var score_on_death := 150


func _process(_delta: float) -> void:
	if is_equal_approx(progress_ratio, 1.0):
		queue_free()


func _physics_process(delta: float) -> void:
	progress_ratio += speed * delta


func _on_cheese_hunter_hit() -> void:
	score_added.emit(score_on_death)
	AudioManager.play(AudioManager.SFX.HunterDeath, randf_range(0.6, 0.7))
	await $CheeseHunter.die()
	queue_free()
