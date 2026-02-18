extends Projectile


@onready var right_sprite: Sprite2D = $RightSprite
@onready var left_sprite: Sprite2D = $LeftSprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var gpu_particles_2d: GPUParticles2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mice"):
		body.take_damage()
		
	if body.is_in_group("enemy"):
		body.take_damage()
	
	queue_free()
