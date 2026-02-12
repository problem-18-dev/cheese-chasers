extends Floater


signal hit(position: Vector2, scale: int, mice_on_death: int, run_from: Vector2)
signal score_added(score: int)

@export_category("Score")
@export var base_score := 35
@export var score_multiplier := 1
@export_category("Movement")
@export var min_speed := 50.0
@export var max_speed := 150.0
@export_category("Rotation")
@export var min_rotation := PI / 2
@export var max_rotation := TAU
@export_category("Death")
@export var mice_on_death := 2

var _scale: int
var _direction: Vector2

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D


func _ready() -> void:
	super()
	var new_rotation := Vector2.UP.angle_to(_direction)
	sprite_2d.rotate(new_rotation)
	collision_shape_2d.rotate(new_rotation)
	_scale_up()


func start(start_position: Vector2, start_direction: Vector2, start_scale: int) -> void:
	_change_size(start_scale)
	var speed := randf_range(min_speed, max_speed)
	
	position = start_position
	linear_velocity = start_direction * speed
	_direction = start_direction
	

func take_damage(run_from = null) -> void:
	if _scale > 1:
		hit.emit(position, _scale, mice_on_death, run_from)
	
	_add_score()
	sprite_2d.hide()
	collision_shape_2d.set_deferred("disabled", true)
	gpu_particles_2d.emitting = true
	await gpu_particles_2d.finished
	queue_free()


func _add_score() -> void:
	var score_to_add := base_score * _scale * score_multiplier
	score_added.emit(score_to_add)


func _change_size(start_scale: int) -> void:
	assert(start_scale > 0, "Starting scale for mouse is invalid.")
	
	# Create new shape
	var old_shape: Vector2 = $CollisionShape2D.shape.size
	var new_shape := RectangleShape2D.new()
	new_shape.size = Vector2(old_shape.x * start_scale, old_shape.y * start_scale)
	$CollisionShape2D.set_deferred("shape", new_shape)
	
	# Scale texture
	$Sprite2D.apply_scale(Vector2(start_scale, start_scale))
	
	_scale = start_scale


func _scale_up() -> void:
	sprite_2d.scale = Vector2.ONE * (_scale - 1)
	var tween := create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2.ONE * _scale, 0.2)
