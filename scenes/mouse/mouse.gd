extends Floater


signal hit(position: Vector2, scale: int, mice_on_death: int, run_from: Vector2)
signal score_added(score: int)

@export_category("Score")
@export var base_score := 35
@export var score_multiplier := 1
@export_category("Movement")
@export var min_speed := 50.0
@export var max_speed := 125.0
@export_category("Rotation")
@export var min_rotation := PI / 2
@export var max_rotation := TAU
@export_category("Death")
@export var mice_on_death := 2

var _scale: int
var _direction: Vector2

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D


func _ready() -> void:
	super()
	_spawn()


func _spawn() -> void:
	# Rotate
	var new_rotation := Vector2.UP.angle_to(_direction)
	animated_sprite_2d.rotate(new_rotation)
	collision_shape_2d.rotate(new_rotation)
	
	_adjust_collision_shape(_scale)
	_adapt_difficulty()
	
	var tween := create_tween().set_parallel()
	tween.tween_property(animated_sprite_2d, "scale", animated_sprite_2d.scale * _scale, 0.2)
	tween.tween_property(gpu_particles_2d, "scale", gpu_particles_2d.scale * _scale, 0.2)


func start(start_position: Vector2, start_direction: Vector2, new_scale: int) -> void:
	var speed := randf_range(min_speed, max_speed)
	
	position = start_position
	linear_velocity = start_direction * speed
	_direction = start_direction
	_scale = new_scale
	

func take_damage(run_from = null) -> void:
	if _scale > 1:
		hit.emit(position, _scale, mice_on_death, run_from)
	
	_add_score()
	animated_sprite_2d.hide()
	collision_shape_2d.set_deferred("disabled", true)
	gpu_particles_2d.emitting = true 


func _add_score() -> void:
	var score_to_add := base_score * _scale * score_multiplier
	score_added.emit(score_to_add)


func _adjust_collision_shape(new_scale: int) -> void:
	assert(new_scale > 0, "Starting scale for mouse is invalid.")
	
	var old_shape: CapsuleShape2D = collision_shape_2d.shape
	var new_shape := CapsuleShape2D.new()
	new_shape.radius = old_shape.radius * new_scale
	new_shape.height = old_shape.height * new_scale
	collision_shape_2d.set_deferred("shape", new_shape)
	
	
func _adapt_difficulty() -> void:
	if GameManager.difficulty == GameManager.Difficulty.Hard:
		min_speed *= 1.5
		max_speed *= 1.5 


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
