extends Floater


signal hit

const FORCE_MULTIPLIER := 100.0

@export_category("Speeds")
@export var acceleration_force := 130.0
@export var turn_force := 5.0

@export_category("Effects")
@export var shoot_recoil := 25.0
@export var is_invincible := false

@export_category("Projectile")
@export var projectile_scene: PackedScene
@export var shoot_cooldown := 0.2

var _can_shoot := true

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gun_marker_2d: Marker2D = $GunMarker2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var death_particles: GPUParticles2D = $DeathParticles


func _ready() -> void:
	super()
	wrapping = false
	set_physics_process(false)
	set_process_unhandled_key_input(false)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		var force := Vector2.UP.rotated(rotation) * acceleration_force * FORCE_MULTIPLIER
		apply_force(force * delta)
		
	var turn_direction := Input.get_axis("turn_left", "turn_right")
	rotate(turn_direction * turn_force * delta)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and _can_shoot:
		_shoot()


func allow_movement() -> void:
	wrapping = true
	set_physics_process(true)
	set_process_unhandled_key_input(true)
	

func increase_shoot_speed(cooldown_decrease: float) -> void:
	shoot_cooldown -= cooldown_decrease


func _shoot() -> void:
	if not _can_shoot:
		return
	
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.start(gun_marker_2d.global_position, rotation)
	get_tree().get_first_node_in_group("projectiles").add_child(projectile)
	
	# Apply firing recoil
	apply_impulse(shoot_recoil * Vector2.DOWN.rotated(rotation))
	
	# Start cooldown
	_can_shoot = false
	cooldown_timer.start(shoot_cooldown)


func _take_damage() -> void:
	hit.emit()
	if GameManager.lives <= 0:
		_die()
	else:
		animation_player.play("take_damage")


func _die() -> void:
	set_process_unhandled_key_input(false)
	set_physics_process(false)
	collision_shape_2d.set_deferred("disabled", true)
	sprite_2d.hide()
	death_particles.emitting = true


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true


func _on_body_entered(body: Node) -> void:
	if is_invincible:
		return
	
	if body.is_in_group("mice"):
		_take_damage()
		body.take_damage(position)


func _on_death_particles_finished() -> void:
	queue_free()
