extends Node


@onready var _mouse_scene: PackedScene = load("res://scenes/mouse/mouse.tscn")
@onready var _spawn_marker: PathFollow2D = $SpawnPath/SpawnLocation
@onready var _mice: Node = $Mice


func _ready() -> void:
	_spawn_mice(3)


func _spawn_mice(amount: int) -> void:
	for i in amount:
		var mouse := _mouse_scene.instantiate()
		_spawn_marker.progress_ratio = randf()
		var direction := _spawn_marker.rotation + PI / 2
		direction += randf_range(-PI / 4, PI / 4)
		mouse.start(_spawn_marker.position, direction, 3)
		mouse.hit.connect(_on_mouse_hit)
		_mice.add_child(mouse)
		

func _on_mouse_hit(hit_position: Vector2, scale: int) -> void:
	# Create two smaller mice
	for i in scale - 1:
		pass
