class_name PowerUp
extends Area2D


signal picked_up(type: String, duration: float)

enum Type { Score, Shield, Shooting }

@export_category("Values")
@export var type: Type
@export var duration := 5.0

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var power_up_life_timer: Timer = $PowerUpLifeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _process(_delta: float) -> void:
	if animation_player.is_playing():
		return
	
	if power_up_life_timer.time_left <= 1.0:
		animation_player.play("near_death")


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	picked_up.emit(type, duration)
	AudioManager.play(AudioManager.SFX.PowerUp)
	power_up_life_timer.stop()
	animation_player.stop()
	set_process(false)
	collision_shape_2d.set_deferred("disabled", false)
	animated_sprite_2d.hide()
	gpu_particles_2d.emitting = true
	await gpu_particles_2d.finished
	queue_free()
