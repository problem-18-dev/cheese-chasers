extends Floater


signal hit

const FORCE_MULTIPLIER := 100.0

@export_category("Speeds")
@export var acceleration_force := 130.0
@export var turn_force := 5.0

@export_category("Effects")
@export var shoot_recoil := 20.0
@export var is_invincible := false
@export var can_shoot_faster := false

@export_category("Projectile")
@export var projectile_scene: PackedScene
@export var blue_projectile_scene: PackedScene
@export var shoot_cooldown := 0.25

var _can_shoot := true

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gun_marker_2d: Marker2D = $GunMarker2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_particles: GPUParticles2D = $DeathParticles
@onready var shield_sprite: AnimatedSprite2D = $ShieldSprite
@onready var thrust_particles: GPUParticles2D = $ThrustParticles


func _ready() -> void:
	super()
	wrapping = false
	set_physics_process(false)
	set_process_unhandled_key_input(false)


func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_rotation(delta)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and _can_shoot:
		_shoot()
		

func _handle_movement(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		var force := Vector2.UP.rotated(rotation) * acceleration_force * FORCE_MULTIPLIER
		apply_force(force * delta)
		thrust_particles.process_material.initial_velocity_max = 64.0
		return
	
	thrust_particles.process_material.initial_velocity_max = 32.0


func _handle_rotation(delta: float) -> void:
	var turn_direction := Input.get_axis("turn_left", "turn_right")
	rotate(turn_direction * turn_force * delta)


func allow_movement() -> void:
	wrapping = true
	set_physics_process(true)
	set_process_unhandled_key_input(true)


func increase_shooting_speed(duration: float) -> void:
	can_shoot_faster = true
	animated_sprite_2d.play("Fast", 0)
	await get_tree().create_timer(duration).timeout
	animated_sprite_2d.play("Normal", 0)
	can_shoot_faster = false
	

func make_invincible(duration: float) -> void:
	set_collision_mask_value(2, false)
	shield_sprite.show()
	await get_tree().create_timer(duration).timeout
	set_collision_mask_value(2, true)
	shield_sprite.hide()
	collision_shape_2d.set_deferred("disabled", false)
	

func take_damage() -> void:
	hit.emit()
	if GameManager.lives <= 0:
		_die()
	else:
		animation_player.play("take_damage")


func _shoot() -> void:
	if not _can_shoot:
		return
	
	var projectile: Projectile
	if can_shoot_faster:
		projectile = blue_projectile_scene.instantiate()
	else:
		projectile = projectile_scene.instantiate()
	projectile.start(gun_marker_2d.global_position, rotation)
	get_tree().get_first_node_in_group("projectiles").add_child(projectile)
	
	# Play shoot animation
	animated_sprite_2d.play("Fast" if can_shoot_faster else "Normal")
	
	# Apply firing recoil
	var recoil := shoot_recoil * 0.1 if can_shoot_faster else shoot_recoil
	apply_impulse(recoil * Vector2.DOWN.rotated(rotation))
	
	# Start cooldown
	_can_shoot = false
	var cooldown := shoot_cooldown * 0.1 if can_shoot_faster else shoot_cooldown
	cooldown_timer.start(cooldown)


func _die() -> void:
	set_process_unhandled_key_input(false)
	set_physics_process(false)
	collision_shape_2d.set_deferred("disabled", true)
	animated_sprite_2d.hide()
	thrust_particles.emitting = false
	death_particles.emitting = true


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true


func _on_death_particles_finished() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if is_invincible:
		return
		
	take_damage()
	body.take_damage(position)
