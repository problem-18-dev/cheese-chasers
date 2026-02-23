extends Area2D


signal hit

@export_category("Projectile")
@export var projectile_scene: PackedScene
@export_category("Movement")
@export var rotation_speed := 15.0

@onready var shoot_timer: Timer = $ShootTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var player := get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	sprite_2d.rotation += rotation_speed * delta
	

func take_damage() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	shoot_timer.stop()
	sprite_2d.hide()
	death_particles.emitting = true
	await death_particles.finished
	hit.emit()
	queue_free()


func _on_shoot_timer_timeout() -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	
	# Get angle to player
	var angle_to_player := global_position.angle_to_point(player.position)
	
	# Offset for projectile's default rotation + inaccuracy
	var inaccuracy := randf_range(deg_to_rad(-10.0), deg_to_rad(10.0))
	angle_to_player += PI / 2 + inaccuracy
	
	projectile.start(global_position, angle_to_player)
	get_tree().get_first_node_in_group("projectiles").add_child(projectile)


func _on_body_entered(body: Node2D) -> void:
	body.take_damage()
	take_damage()
