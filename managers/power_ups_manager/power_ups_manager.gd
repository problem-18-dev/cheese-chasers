extends Node


signal double_score_enabled(duration: float)

@export_category("Nodes")
@export var player: RigidBody2D
@export var hud: CanvasLayer
@export var spawn_node: Node

var _powerups_to_spawn: Array[PackedScene] = [
	preload("res://scenes/powerup/score_power_up/score_power_up.tscn"),
	preload("res://scenes/powerup/shooting_power_up/shooting_power_up.tscn"),
	preload("res://scenes/powerup/shield_power_up/shield_power_up.tscn"),
]

@export_category("Spawning")
@export_range(1.0, 100.0) var powerup_spawn_interval := 10.0
@export var powerup_spawn_offset := Vector2(50, 25)

var _screen_size: Vector2

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	_screen_size = get_viewport().get_visible_rect().size
	spawn_timer.wait_time = powerup_spawn_interval
	spawn_timer.start()


func _spawn_powerup() -> void:
	var powerup_scene = _powerups_to_spawn.pick_random()
	var powerup: PowerUp = powerup_scene.instantiate()
	var spawn_position_x := randf_range(0 + powerup_spawn_offset.x, _screen_size.x - powerup_spawn_offset.x)
	var spawn_position_y := randf_range(0 + powerup_spawn_offset.y, _screen_size.y - powerup_spawn_offset.y)
	powerup.position = Vector2(spawn_position_x, spawn_position_y)
	powerup.picked_up.connect(_on_powerup_picked_up)
	spawn_node.add_child(powerup)


func _on_spawn_timer_timeout() -> void:
	_spawn_powerup()


func _on_powerup_picked_up(type: PowerUp.Type, duration: float) -> void:
	match (type):
		PowerUp.Type.Shield:
			player.make_invincible(duration)
		PowerUp.Type.Score:
			double_score_enabled.emit(duration)
		PowerUp.Type.Shooting:
			player.increase_shooting_speed(duration)
