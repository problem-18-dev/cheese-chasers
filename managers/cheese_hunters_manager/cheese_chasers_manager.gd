extends Node

@export_category("Scene")
@export var cheese_hunter_scene: PackedScene
@export_category("Speed")
@export var spawn_interval := 40.0
@export var spawn_interval_offset := 5.0

@onready var paths := [$LeftPath2D, $RightPath2D]
@onready var timer: Timer = $Timer


func _ready() -> void:
	_start_timer()


func _start_timer() -> void:
	var offset := randf_range(-spawn_interval_offset, spawn_interval_offset)
	var time := spawn_interval + offset
	timer.start(time)


func _spawn_cheese_hunter() -> void:
	var path: Path2D = paths.pick_random()
	var cheese_hunter: PathFollow2D = cheese_hunter_scene.instantiate()
	path.add_child(cheese_hunter)


func _on_timer_timeout() -> void:
	_spawn_cheese_hunter()
	_start_timer()
