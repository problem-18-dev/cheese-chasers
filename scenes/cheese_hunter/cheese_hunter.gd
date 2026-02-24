extends Area2D


signal hit

@export_category("Projectile")
@export var projectile_scene: PackedScene
@export_category("Movement")
@export var ship_rotation_speed := 3.0
@export var mouse_rotation_speed := 3.0

@onready var shoot_timer: Timer = $ShootTimer
@onready var ship_sprite: Sprite2D = $Sprites/ShipSprite
@onready var mouse_sprite: Sprite2D = $Sprites/MouseSprite
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprites: Node2D = $Sprites
@onready var player := get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	_rotate_ship(delta)
	_rotate_mouse(delta)


func take_damage() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	shoot_timer.stop()
	sprites.hide()
	death_particles.emitting = true
	await death_particles.finished
	hit.emit()
	queue_free()


func _rotate_ship(delta: float) -> void:
	ship_sprite.rotation += ship_rotation_speed * delta
	

func _rotate_mouse(delta: float) -> void:
	var direction_to_player := global_position.direction_to(player.position)
	var rotation_speed := mouse_rotation_speed * delta
	var angle := -atan2(direction_to_player.x, direction_to_player.y)
	mouse_sprite.rotation = lerpf(mouse_sprite.rotation, angle, rotation_speed)


func _on_shoot_timer_timeout() -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	
	# Get angle to player
	var angle_to_player := global_position.angle_to_point(player.position)
	
	# Offset for projectile's default rotation + inaccuracy
	var inaccuracy := randf_range(deg_to_rad(-10.0), deg_to_rad(10.0))
	angle_to_player += PI / 2 + inaccuracy
	
	# Fire
	projectile.start(global_position, angle_to_player)
	get_tree().get_first_node_in_group("projectiles").add_child(projectile)


func _on_body_entered(body: Node2D) -> void:
	body.take_damage()
	take_damage()
