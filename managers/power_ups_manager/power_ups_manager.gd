extends Node


signal double_score_enabled(duration: float)

@export_category("Nodes")
@export var player: RigidBody2D
@export var hud: CanvasLayer
@export var spawn_node: Node

@export_category("Spawning")
@export var powerups_to_spawn: Array[PackedScene]
@export_range(1.0, 100.0) var powerup_spawn_interval := 10.0

var _screen_size: Vector2

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	_screen_size = get_viewport().get_visible_rect().size
	spawn_timer.wait_time = powerup_spawn_interval
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	var powerup_scene = powerups_to_spawn.pick_random()
	var powerup: PowerUp = powerup_scene.instantiate()
	powerup.position.x = randf_range(0, _screen_size.x)
	powerup.position.y = randf_range(0, _screen_size.y)
	powerup.picked_up.connect(_on_powerup_picked_up)
	spawn_node.add_child(powerup)


func _on_powerup_picked_up(type: String, duration: float) -> void:
	match (type):
		"Invincibility":
			player.make_invincible(duration)
			print("Adjusting HUD for invincibility")
		"Score":
			double_score_enabled.emit(duration)
			print("Adjusting HUD for score")
		"Shooting":
			player.increase_shooting_speed(duration)
			print("Adjusting HUD for shooting")
		_:
			assert(false, "Invalid powerup type picked up")
