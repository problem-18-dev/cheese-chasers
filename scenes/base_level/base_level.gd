extends Node


@export_category("Level")
@export var start_mice := 3

@onready var _mouse_scene: PackedScene = load("res://scenes/mouse/mouse.tscn")
@onready var _spawn_marker: PathFollow2D = $SpawnPath/SpawnLocation
@onready var _mice: Node = $Mice


func _ready() -> void:
	_spawn_mice()


func _spawn_mice() -> void:
	for i in start_mice:
		var mouse := _mouse_scene.instantiate()
		
		# Position
		_spawn_marker.progress_ratio = randf()
		var position := _spawn_marker.position
		
		# Direction
		var direction_rotation = _spawn_marker.rotation + PI / 2
		direction_rotation += randf_range(-PI / 4, PI / 4)
		var direction := Vector2(1, 0).rotated(direction_rotation)
		
		# Spawn
		mouse.start(position, direction, 3)
		mouse.hit.connect(_on_mouse_hit)
		_mice.add_child(mouse)
		

func _on_mouse_hit(hit_position: Vector2, direction: Vector2, scale: int, count: int) -> void:
	for i in count:
		var mouse := _mouse_scene.instantiate()
		var spawn_rotation := randf_range(-PI / 2,  PI / 2)
		var spawn_direction := direction.rotated(spawn_rotation)
		mouse.start(hit_position, spawn_direction, scale - 1)
		mouse.hit.connect(_on_mouse_hit)
		_mice.add_child(mouse)
