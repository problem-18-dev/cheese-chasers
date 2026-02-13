extends Node


@export_category("Level")
@export var start_mice := 3
@export var start_mice_scale := 3

var _score := 0

@onready var _mouse_scene: PackedScene = load("res://scenes/mouse/mouse.tscn")
@onready var _player_scene: PackedScene = load("res://scenes/player/player.tscn")
@onready var _spawn_marker: PathFollow2D = $SpawnPath/SpawnLocation
@onready var _mice: Node = $Mice
@onready var shake_camera_2d: Camera2D = $ShakeCamera2D
@onready var hud: CanvasLayer = $HUD
@onready var _total_mice := start_mice


func _ready() -> void:
	_spawn_player()
	_spawn_mice()
	

func _process(_delta: float) -> void:
	var mice_in_game := _mice.get_child_count()
	if mice_in_game <= 0:
		_total_mice += 1
		_spawn_mice()

func _spawn_player() -> void:
	var player := _player_scene.instantiate()
	player.start($PlayerSpawnPosition.position)
	player.hit.connect(_on_player_hit)
	add_child(player)


func _spawn_mice() -> void:
	for i in _total_mice:
		var mouse := _mouse_scene.instantiate()
		
		# Position
		_spawn_marker.progress_ratio = randf()
		var position := _spawn_marker.position
		
		# Direction
		var direction_rotation = _spawn_marker.rotation + PI / 2
		direction_rotation += randf_range(-PI / 4, PI / 4)
		var direction := Vector2(1, 0).rotated(direction_rotation)
		
		# Spawn
		mouse.hit.connect(_on_mouse_hit)
		mouse.score_added.connect(_add_score)
		mouse.start(position, direction, start_mice_scale)
		_mice.add_child(mouse)


func _add_score(score_to_add: int) -> void:
	_score += score_to_add
	GameManager.add_score(score_to_add)
	hud.change_score(GameManager.score)


func _on_mouse_hit(hit_position: Vector2, scale: int, count: int, run_from = null) -> void:
	for i in count:
		var mouse := _mouse_scene.instantiate()
		
		# Run away from player, else random direction
		var spawn_rotation: float
		var spawn_direction: Vector2
		if run_from:
			spawn_rotation = randf_range(-PI / 4, PI / 4)
			var direction_to_player := hit_position.direction_to(run_from)
			spawn_direction = direction_to_player.rotated(PI + spawn_rotation)
		else:
			spawn_rotation = randf_range(-PI,  PI)
			spawn_direction = Vector2.UP.rotated(spawn_rotation)
		
		mouse.hit.connect(_on_mouse_hit)
		mouse.score_added.connect(_add_score)
		mouse.start(hit_position, spawn_direction, scale - 1)
		_mice.call_deferred("add_child", mouse)


func _on_player_hit() -> void:
	GameManager.take_life()
	hud.change_lives(GameManager.lives)
	shake_camera_2d.small_shake()
