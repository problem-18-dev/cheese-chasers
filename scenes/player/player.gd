extends Floater


const FORCE_MULTIPLIER := 100.0

@export_category("Speeds")
@export var acceleration_force := 120.0
@export var turn_force := 200.0

@export_category("Effects")
@export var shoot_recoil := 10.0

@export_category("Projectile")
@export var projectile_scene: PackedScene


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		var force := Vector2.DOWN.rotated(rotation) * acceleration_force * FORCE_MULTIPLIER
		apply_force(force * delta)
		
	var turn_direction := Input.get_axis("turn_left", "turn_right")
	apply_torque(turn_direction * turn_force * FORCE_MULTIPLIER * delta)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_shoot()


func _shoot() -> void:
	var projectile_left: Projectile = projectile_scene.instantiate()
	var projectile_right: Projectile = projectile_scene.instantiate()
	projectile_left.start($LeftGunMarker2D.global_position, rotation)
	projectile_right.start($RightGunMarker2D.global_position, rotation)
	get_tree().root.add_child(projectile_left)
	get_tree().root.add_child(projectile_right)
	
	# Apply firing recoil
	apply_impulse(shoot_recoil * Vector2.UP.rotated(rotation))
