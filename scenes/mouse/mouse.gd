extends Floater


signal hit(position: Vector2, direction: Vector2, scale: int, mice_on_death: int)

@export_category("Movement")
@export var min_speed := 50.0
@export var max_speed := 150.0

@export_category("Rotation")
@export var min_rotation := PI / 2
@export var max_rotation := TAU

@export_category("Death")
@export var mice_on_death := 2

var _scale: int

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func start(start_position: Vector2, start_direction: Vector2, start_scale: int) -> void:
	_change_size(start_scale)
	var speed := randf_range(min_speed, max_speed)
	
	position = start_position
	linear_velocity = start_direction * speed
	angular_velocity = randf_range(min_rotation, max_rotation)
	

func take_damage() -> void:
	if _scale > 1:
		hit.emit(position, linear_velocity.normalized(), _scale, mice_on_death)
		
	queue_free()

func _change_size(start_scale: int) -> void:
	assert(start_scale > 0, "Starting scale for mouse is invalid.")
	
	# Create new shape
	var old_shape: Vector2 = $CollisionShape2D.shape.size
	var new_shape := RectangleShape2D.new()
	new_shape.size = Vector2(old_shape.x * start_scale, old_shape.y * start_scale)
	$CollisionShape2D.shape = new_shape
	
	# Scale texture
	$Sprite2D.apply_scale(Vector2(start_scale, start_scale))
	
	_scale = start_scale
